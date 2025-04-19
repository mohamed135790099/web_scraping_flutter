import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:web_scraping_flutter/google_drive/file_manager.dart';
import 'package:web_scraping_flutter/google_drive/login_google.dart';

import ' drive_service.dart';


class DriveScreen extends StatefulWidget {
  const DriveScreen({super.key});

  @override
  State<DriveScreen> createState() => _DriveScreenState();
}

class _DriveScreenState extends State<DriveScreen> {
  final AuthService _auth = AuthService();
  final GoogleDriveService _drive = GoogleDriveService();
  final ImagePicker _picker = ImagePicker();

  List<drive.File> _files = [];
  List<drive.File> _folders = [];
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _currentFolderId;
  String _currentGroupName = '';
  final TextEditingController _groupNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    setState(() => _isLoading = true);
    try {
      _isAuthenticated = await _auth.isSignedIn();
      if (_isAuthenticated) {
        await _loadFoldersAndFiles();
      }
    } catch (e) {
      _showErrorSnackbar('Failed to check authentication');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _authenticate() async {
    setState(() => _isLoading = true);
    try {
      final user = await _auth.signInWithGoogle();
      if (user != null) {
        setState(() => _isAuthenticated = true);
        await _loadFoldersAndFiles();
        _showSuccessSnackbar('Successfully authenticated');
      }
    } catch (e) {
      _showErrorSnackbar('Failed to authenticate. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadFoldersAndFiles() async {
    setState(() => _isLoading = true);
    try {
      final items = await _drive.listFiles(folderId: _currentFolderId);

      _folders = items.where((f) => f.mimeType == 'application/vnd.google-apps.folder').toList();
      _files = items.where((f) => f.mimeType != 'application/vnd.google-apps.folder').toList();

      setState(() {});
    } catch (e) {
      _showErrorSnackbar('Failed to load items');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createNewGroup() async {
    if (_groupNameController.text.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final folderId = await _drive.createFolder(_groupNameController.text,
          parentFolderId: _currentFolderId);

      if (folderId != null) {
        _showSuccessSnackbar('Group created successfully');
        _groupNameController.clear();
        await _loadFoldersAndFiles();
      }
    } catch (e) {
      _showErrorSnackbar('Failed to create group');
    } finally {
      setState(() => _isLoading = false);
      Navigator.pop(context); // Close the dialog
    }
  }

  Future<void> _uploadFile(File file, {String? customName}) async {
    setState(() => _isLoading = true);
    try {
      final fileId = await _drive.uploadFile(file,
          folderId: _currentFolderId,
          customName: customName);

      if (fileId != null) {
        _showSuccessSnackbar('File uploaded successfully');
        await _loadFoldersAndFiles();
      }
    } catch (e) {
      _showErrorSnackbar('Upload failed');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectFile() async {
    final result = await showModalBottomSheet<File?>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Photo from gallery'),
              onTap: () async {
                Navigator.pop(context, await _pickImage(ImageSource.gallery));
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              onTap: () async {
                Navigator.pop(context, await _pickImage(ImageSource.camera));
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_library),
              title: const Text('Video from gallery'),
              onTap: () async {
                Navigator.pop(context, await _pickVideo(ImageSource.gallery));
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Record a video'),
              onTap: () async {
                Navigator.pop(context, await _pickVideo(ImageSource.camera));
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: const Text('Select document'),
              onTap: () async {
                Navigator.pop(context, await _pickDocument());
              },
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      await _uploadFile(result);
    }
  }

  Future<File?> _pickImage(ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        final status = await Permission.camera.request();
        if (!status.isGranted) return null;
      } else {
        final status = await Permission.photos.request();
        if (!status.isGranted) return null;
      }

      final XFile? image = await _picker.pickImage(source: source);
      return image != null ? File(image.path) : null;
    } catch (e) {
      _showErrorSnackbar('Failed to pick image');
      return null;
    }
  }

  Future<File?> _pickVideo(ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        final status = await Permission.camera.request();
        if (!status.isGranted) return null;
      } else {
        final status = await Permission.photos.request();
        if (!status.isGranted) return null;
      }

      final XFile? video = await _picker.pickVideo(source: source);
      return video != null ? File(video.path) : null;
    } catch (e) {
      _showErrorSnackbar('Failed to pick video');
      return null;
    }
  }

  Future<File?> _pickDocument() async {
    try {
      final status = await Permission.storage.request();
      if (!status.isGranted) return null;

      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
      return null;
    } catch (e) {
      _showErrorSnackbar('Failed to pick document');
      return null;
    }
  }

  Future<void> _downloadOrOpenFile(drive.File driveFile) async {
    setState(() => _isLoading = true);
    try {
      // Check if file exists locally
      final localFile = File('${await FileManager.appDocumentsDir}/${driveFile.name}');

      if (await localFile.exists()) {
        _showSuccessSnackbar('Opening existing file');
        _openFile(localFile);
        return;
      }

      // Download if not exists
      final downloadedFile = await _drive.downloadFile(driveFile.id!, driveFile.name!);
      if (downloadedFile != null) {
        _showSuccessSnackbar('File saved to: ${downloadedFile.path}');
        _openFile(downloadedFile);
      }
    } catch (e) {
      _showErrorSnackbar('Failed to open file: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _openFile(File file) async {
    try {
      final result = await OpenFile.open(file.path);
      if (result.type != ResultType.done) {
        _showErrorSnackbar('Could not open file: ${result.message}');
      }
    } catch (e) {
      _showErrorSnackbar('Could not open file');
    }
  }

  void _showCreateGroupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Group'),
        content: TextField(
          controller: _groupNameController,
          decoration: const InputDecoration(hintText: 'Enter group name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: _createNewGroup,
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentFolderId == null ? 'Google Drive' : 'Group Files'),
        actions: [
          if (_isAuthenticated) ...[
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadFoldersAndFiles,
            ),
            IconButton(
              icon: const Icon(Icons.create_new_folder),
              onPressed: _showCreateGroupDialog,
            ),
            IconButton(
              icon: Icon(_isAuthenticated ? Icons.logout : Icons.login),
              onPressed: _isAuthenticated ? _auth.signOut : _authenticate,
            ),
          ],
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _isAuthenticated
          ? FloatingActionButton(
        onPressed: _selectFile,
        tooltip: 'Upload file',
        child: const Icon(Icons.add),
      )
          : null,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_isAuthenticated) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You need to authenticate first'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _authenticate,
              child: const Text('Sign in with Google'),
            ),
          ],
        ),
      );
    }

    if (_folders.isEmpty && _files.isEmpty) {
      return const Center(child: Text('No items found'));
    }

    return ListView(
      children: [
        if (_folders.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Groups',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ..._folders.map((folder) => _buildFolderItem(folder)),
        if (_files.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Files',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ..._files.map((file) => _buildFileItem(file)),
      ],
    );
  }

  Widget _buildFolderItem(drive.File folder) {
    return ListTile(
      leading: const Icon(Icons.folder, color: Colors.amber),
      title: Text(folder.name ?? 'Untitled Folder'),
      subtitle: Text(_formatDate(folder.modifiedTime)),
      onTap: () {
        setState(() {
          _currentFolderId = folder.id;
          _currentGroupName = folder.name ?? '';
        });
        _loadFoldersAndFiles();
      },
    );
  }

  Widget _buildFileItem(drive.File file) {
    return ListTile(
      leading: _getFileIcon(file),
      title: Text(file.name ?? 'Untitled File'),
      subtitle: Text(
        '${_formatFileSize(int.parse(file.size ?? "0"))} • ${_formatDate(file.modifiedTime)}',
      ),
      onTap: () => _downloadOrOpenFile(file),
    );
  }

  Widget _getFileIcon(drive.File file) {
    final mimeType = file.mimeType ?? '';
    if (mimeType.contains('image')) {
      return const Icon(Icons.image, color: Colors.blue);
    } else if (mimeType.contains('video')) {
      return const Icon(Icons.videocam, color: Colors.red);
    } else if (mimeType.contains('pdf')) {
      return const Icon(Icons.picture_as_pdf, color: Colors.red);
    } else if (mimeType.contains('audio')) {
      return const Icon(Icons.audiotrack, color: Colors.purple);
    }
    return const Icon(Icons.insert_drive_file);
  }

  String _formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    final i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }

  String _formatDate(DateTime? date) {
    return date != null
        ? DateFormat('MMM dd, yyyy - hh:mm a').format(date)
        : 'Unknown date';
  }
}