// main.dart - COMPLETE BOCKDOCS APPLICATION
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for Clipboard
import 'config/api_config.dart';       // adjust path to your ApiConfig


void main() => runApp(const BockDocsApp());

class BockDocsApp extends StatelessWidget {
  const BockDocsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BockDocs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF7C3AED),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF7C3AED),
          secondary: const Color(0xFF9333EA),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
        '/editor': (context) => const EditorPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}

// ==================== EDITOR PAGE ====================
class EditorPage extends StatefulWidget {
  const EditorPage({Key? key}) : super(key: key);
  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final _titleController = TextEditingController(text: 'Untitled document');
  final _contentController = TextEditingController();
  final _contentFocusNode = FocusNode();
  final _scrollController = ScrollController();
  String _selectedFont = 'Arial';
  double _fontSize = 16;
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  TextAlign _textAlign = TextAlign.left;
  bool _showOutline = true;
  OverlayEntry? _currentOverlay;
  List<DocumentSection> _documentSections = [];

  @override
  void initState() {
    super.initState();
    _contentController.addListener(_updateDocumentOutline);
    _updateDocumentOutline();
  }

  void _updateDocumentOutline() {
    final text = _contentController.text;
    final lines = text.split('\n');
    List<DocumentSection> sections = [];
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isNotEmpty && (line.endsWith(':') || (line.length < 50 && line.length > 3 && !line.contains('.')))) {
        sections.add(DocumentSection(title: line, lineNumber: i + 1));
      }
    }
    setState(() => _documentSections = sections);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF0F172A),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(111),
        child: Container(
          decoration: BoxDecoration(color: const Color(0xFF1E293B), border: Border(bottom: BorderSide(color: Color(0xFF334155)))),
          child: Column(
            children: [
              Container(
                
                height: 64,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF9333EA)]), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.description_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _titleController,
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                        decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.cloud_done_rounded, color: Color(0xFF10B981)), onPressed: () {}, tooltip: 'All changes saved'),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _showShareDialog(context, 'doc123'), // pass actual document ID
                      icon: const Icon(Icons.share, size: 18),
                      label: const Text('Share'),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                    const SizedBox(width: 16),
                    PopupMenuButton(
                      icon: CircleAvatar(radius: 18, backgroundColor: const Color(0xFF7C3AED), child: const Text('U', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600))),
                      itemBuilder: (context) => [
                        PopupMenuItem(child: Row(children: const [Icon(Icons.settings_rounded, color: Color(0xFF94A3B8), size: 20), SizedBox(width: 12), Text('Settings')]), onTap: () => Future.delayed(Duration.zero, () => Navigator.pushNamed(context, '/settings'))),
                        PopupMenuItem(child: Row(children: const [Icon(Icons.logout, color: Colors.red, size: 20), SizedBox(width: 12), Text('Sign Out', style: TextStyle(color: Colors.red))]), onTap: () => Future.delayed(Duration.zero, () => Navigator.pushReplacementNamed(context, '/login'))),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildMenuButton('File', _showFileMenu),
                    _buildMenuButton('Edit', _showEditMenu),
                    _buildMenuButton('View', _showViewMenu),
                    _buildMenuButton('Insert', _showInsertMenu),
                    _buildMenuButton('Format', _showFormatMenu),
                    _buildMenuButton('Tools', _showToolsMenu),
                    _buildMenuButton('Help', _showHelpMenu),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          _buildToolbar(),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: const Color(0xFF0F172A),
                    child: Center(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Container(
                          width: 816,
                          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - 200),
                          decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20)]),
                          child: TextField(
                            controller: _contentController,
                            focusNode: _contentFocusNode,
                            maxLines: null,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: _fontSize,
                              fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                              fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                              decoration: _isUnderline ? TextDecoration.underline : TextDecoration.none,
                              height: 1.5,
                              fontFamily: _selectedFont,
                            ),
                            textAlign: _textAlign,
                            decoration: const InputDecoration(contentPadding: EdgeInsets.all(96), border: InputBorder.none, hintText: 'Start typing...', hintStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (_showOutline) _buildOutlineSidebar(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: !_showOutline ? FloatingActionButton(onPressed: () => setState(() => _showOutline = true), backgroundColor: const Color(0xFF7C3AED), child: const Icon(Icons.list_alt, color: Colors.white)) : null,
    );
  }

  Widget _buildOutlineSidebar() {
    return Container(
      width: 280,
      decoration: BoxDecoration(color: const Color(0xFF1E293B), border: Border(left: BorderSide(color: Color(0xFF334155)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFF334155)))),
            child: Row(
              children: [
                const Icon(Icons.list_alt, color: Color(0xFF7C3AED), size: 20),
                const SizedBox(width: 12),
                const Text('Document tabs', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                const Spacer(),
                IconButton(icon: const Icon(Icons.close, color: Color(0xFF94A3B8), size: 20), onPressed: () => setState(() => _showOutline = false), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
              ],
            ),
          ),
          Expanded(
            child: _documentSections.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.article_outlined, color: Color(0xFF64748B), size: 48),
                          SizedBox(height: 16),
                          Text('No tabs yet', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14), textAlign: TextAlign.center),
                          SizedBox(height: 8),
                          Text('Add tabs', style: TextStyle(color: Color(0xFF64748B), fontSize: 12), textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _documentSections.length,
                    itemBuilder: (context, index) {
                      final section = _documentSections[index];
                      return InkWell(
                        onTap: () => _contentFocusNode.requestFocus(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Row(
                            children: [
                              Container(width: 4, height: 4, decoration: BoxDecoration(color: const Color(0xFF7C3AED), shape: BoxShape.circle)),
                              const SizedBox(width: 12),
                              Expanded(child: Text(section.title, style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

 void _showShareDialog(BuildContext context, String docId) {
  final emailController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(  // Use StatefulBuilder for state updates
      builder: (context, setState) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.share, color: Color(0xFF7C3AED)),
            const SizedBox(width: 12),
            const Text(
              'Share Document',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Share with people',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter email address',
                        hintStyle: const TextStyle(color: Color(0xFF64748B)),
                        prefixIcon:
                            const Icon(Icons.person_add, color: Color(0xFF7C3AED)),
                        filled: true,
                        fillColor: const Color(0xFF0F172A),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFF7C3AED), width: 2)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      if (emailController.text.isNotEmpty) {
                        // Call backend to share with email
                        final success = await ApiConfig.shareDocumentWithEmail(
                            docId, emailController.text, 'view'); // You can use selectedPermission here

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(success
                                ? 'Shared with ${emailController.text}'
                                : 'Failed to share with ${emailController.text}'),
                            backgroundColor: success
                                ? const Color(0xFF10B981)
                                : Colors.red,
                          ));
                        }
                        emailController.clear();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: const Text('Send', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('General access',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const Icon(Icons.lock, color: Color(0xFF7C3AED)),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Anyone with the link can view',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text('Only people with access can open',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8)))),
          ElevatedButton.icon(
            onPressed: () async {
              // Generate share link
              final link = await ApiConfig.createShareLink(docId, 'view', 3600); // 1 hour expiry

              if (context.mounted) {
                Navigator.pop(context);

                if (link != null) {
                  await Clipboard.setData(ClipboardData(text: link));

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 12),
                          Text('Link copied to clipboard')
                        ],
                      ),
                      backgroundColor: Color(0xFF10B981),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to generate share link'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            icon: const Icon(Icons.link, size: 18),
            label: const Text('Copy Link', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          ),
        ],
      ),
    ),
  );
}



  Widget _buildMenuButton(String text, VoidCallback? onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), minimumSize: Size.zero),
      child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }

  void _showFileMenu() => _showDropdownMenu(context, items: [
        _MenuSection(items: [_MenuItem(icon: Icons.insert_drive_file, text: 'New', shortcut: 'Ctrl+N'), _MenuItem(icon: Icons.folder_open, text: 'Open', shortcut: 'Ctrl+O')]),
        _MenuSection(items: [_MenuItem(icon: Icons.share, text: 'Share'), _MenuItem(icon: Icons.download, text: 'Download')]),
        _MenuSection(items: [_MenuItem(icon: Icons.drive_file_rename_outline, text: 'Rename'), _MenuItem(icon: Icons.delete, text: 'Move to trash')]),
        _MenuSection(items: [_MenuItem(icon: Icons.print, text: 'Print', shortcut: 'Ctrl+P')]),
      ]);

  void _showEditMenu() => _showDropdownMenu(context, items: [
        _MenuSection(items: [_MenuItem(icon: Icons.undo, text: 'Undo', shortcut: 'Ctrl+Z'), _MenuItem(icon: Icons.redo, text: 'Redo', shortcut: 'Ctrl+Y')]),
        _MenuSection(items: [_MenuItem(icon: Icons.content_cut, text: 'Cut', shortcut: 'Ctrl+X'), _MenuItem(icon: Icons.content_copy, text: 'Copy', shortcut: 'Ctrl+C'), _MenuItem(icon: Icons.content_paste, text: 'Paste', shortcut: 'Ctrl+V')]),
        _MenuSection(items: [_MenuItem(icon: Icons.select_all, text: 'Select all', shortcut: 'Ctrl+A')]),
      ]);

  void _showViewMenu() => _showDropdownMenu(context, items: [
        _MenuSection(items: [_MenuItem(icon: Icons.print, text: 'Print layout', isChecked: true)]),
        _MenuSection(items: [_MenuItem(icon: Icons.list_alt, text: 'Show document outline', isChecked: _showOutline, onTap: () => setState(() => _showOutline = !_showOutline))]),
        _MenuSection(items: [_MenuItem(icon: Icons.fullscreen, text: 'Full screen', shortcut: 'F11')]),
      ]);

  void _showInsertMenu() => _showDropdownMenu(context, items: [
        _MenuSection(items: [_MenuItem(icon: Icons.image, text: 'Image'), _MenuItem(icon: Icons.table_chart, text: 'Table'), _MenuItem(icon: Icons.insert_chart, text: 'Chart')]),
        _MenuSection(items: [_MenuItem(icon: Icons.horizontal_rule, text: 'Horizontal line'), _MenuItem(icon: Icons.emoji_emotions, text: 'Emoji')]),
        _MenuSection(items: [_MenuItem(icon: Icons.link, text: 'Link', shortcut: 'Ctrl+K'), _MenuItem(icon: Icons.bookmark, text: 'Bookmark')]),
      ]);

  void _showFormatMenu() => _showDropdownMenu(context, items: [
        _MenuSection(items: [_MenuItem(icon: Icons.format_bold, text: 'Bold', shortcut: 'Ctrl+B'), _MenuItem(icon: Icons.format_italic, text: 'Italic', shortcut: 'Ctrl+I'), _MenuItem(icon: Icons.format_underlined, text: 'Underline', shortcut: 'Ctrl+U')]),
        _MenuSection(items: [_MenuItem(icon: Icons.format_size, text: 'Font size', hasSubmenu: true)]),
        _MenuSection(items: [_MenuItem(icon: Icons.format_align_left, text: 'Align & indent', hasSubmenu: true), _MenuItem(icon: Icons.format_line_spacing, text: 'Line spacing', hasSubmenu: true)]),
        _MenuSection(items: [_MenuItem(icon: Icons.format_clear, text: 'Clear formatting', shortcut: 'Ctrl+\\')]),
      ]);

  void _showToolsMenu() => _showDropdownMenu(context, items: [
        _MenuSection(items: [_MenuItem(icon: Icons.spellcheck, text: 'Spelling and grammar'), _MenuItem(icon: Icons.text_fields, text: 'Word count')]),
        _MenuSection(items: [_MenuItem(icon: Icons.translate, text: 'Translate document')]),
        _MenuSection(items: [_MenuItem(icon: Icons.book, text: 'Dictionary')]),
      ]);

  void _showHelpMenu() => _showDropdownMenu(context, items: [
        _MenuSection(items: [_MenuItem(icon: Icons.search, text: 'Search the menus', shortcut: 'Alt+/')]),
        _MenuSection(items: [_MenuItem(icon: Icons.help, text: 'BockDocs Help'), _MenuItem(icon: Icons.school, text: 'Training')]),
        _MenuSection(items: [_MenuItem(icon: Icons.keyboard, text: 'Keyboard shortcuts', shortcut: 'Ctrl+/')]),
      ]);

  void _showDropdownMenu(BuildContext context, {required List<_MenuSection> items}) {
    _currentOverlay?.remove();
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(Rect.fromPoints(button.localToGlobal(Offset.zero, ancestor: overlay), button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay)), Offset.zero & overlay.size);

    _currentOverlay = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(onTap: () {_currentOverlay?.remove(); _currentOverlay = null;}, child: Container(color: Colors.transparent)),
          Positioned(
            left: position.left+10,
            top: position.top+10,
            child: Material(
              elevation: 12,
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFF1E293B),
              child: Container(
                width: 280,
                constraints: const BoxConstraints(maxHeight: 500),
                decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF334155))),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: items.map((section) => Column(children: [...section.items.map((item) => _buildMenuItem(item)), if (section != items.last) const Divider(height: 1, thickness: 1, color: Color(0xFF334155))])).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_currentOverlay!);
  }

  Widget _buildMenuItem(_MenuItem item) {
    return InkWell(
      onTap: () {_currentOverlay?.remove(); _currentOverlay = null; item.onTap?.call();},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            if (item.isChecked) const Icon(Icons.check, size: 18, color: Color(0xFF7C3AED)) else const SizedBox(width: 18),
            const SizedBox(width: 12),
            Icon(item.icon, size: 18, color: const Color(0xFF94A3B8)),
            const SizedBox(width: 12),
            Expanded(child: Text(item.text, style: const TextStyle(fontSize: 14, color: Colors.white))),
            if (item.shortcut != null) Text(item.shortcut!, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
            if (item.hasSubmenu) const Icon(Icons.arrow_right, size: 18, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
  Widget _buildToolbar() {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF1E293B), border: Border(bottom: BorderSide(color: Color(0xFF334155)))),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.undo, size: 20), color: Colors.white, onPressed: () {}, tooltip: 'Undo'),
            IconButton(icon: const Icon(Icons.redo, size: 20), color: Colors.white, onPressed: () {}, tooltip: 'Redo'),
            IconButton(icon: const Icon(Icons.print, size: 20), color: Colors.white, onPressed: () {}, tooltip: 'Print'),
            const VerticalDivider(width: 20, thickness: 1, color: Color(0xFF334155)),
            Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: const Color(0xFF0F172A), border: Border.all(color: const Color(0xFF334155)), borderRadius: BorderRadius.circular(8)),
              child: DropdownButton<String>(
                value: _selectedFont,
                underline: const SizedBox(),
                dropdownColor: const Color(0xFF1E293B),
                style: const TextStyle(color: Colors.white, fontSize: 13),
                items: ['Arial', 'Calibri', 'Times New Roman', 'Verdana'].map((font) => DropdownMenuItem(value: font, child: Text(font))).toList(),
                onChanged: (value) => setState(() => _selectedFont = value!),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 36,
              width: 70,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: const Color(0xFF0F172A), border: Border.all(color: const Color(0xFF334155)), borderRadius: BorderRadius.circular(8)),
              child: DropdownButton<double>(
                value: _fontSize,
                underline: const SizedBox(),
                dropdownColor: const Color(0xFF1E293B),
                style: const TextStyle(color: Colors.white, fontSize: 13),
                items: [10, 12, 14, 16, 18, 20, 24, 28, 36].map((size) => DropdownMenuItem(value: size.toDouble(), child: Text(size.toString()))).toList(),
                onChanged: (value) => setState(() => _fontSize = value!),
              ),
            ),
            const VerticalDivider(width: 20, thickness: 1, color: Color(0xFF334155)),
            IconButton(icon: const Icon(Icons.format_bold, size: 20), color: _isBold ? const Color(0xFF7C3AED) : Colors.white, onPressed: () => setState(() => _isBold = !_isBold), tooltip: 'Bold'),
            IconButton(icon: const Icon(Icons.format_italic, size: 20), color: _isItalic ? const Color(0xFF7C3AED) : Colors.white, onPressed: () => setState(() => _isItalic = !_isItalic), tooltip: 'Italic'),
            IconButton(icon: const Icon(Icons.format_underlined, size: 20), color: _isUnderline ? const Color(0xFF7C3AED) : Colors.white, onPressed: () => setState(() => _isUnderline = !_isUnderline), tooltip: 'Underline'),
            const VerticalDivider(width: 20, thickness: 1, color: Color(0xFF334155)),
            IconButton(icon: const Icon(Icons.format_align_left, size: 20), color: _textAlign == TextAlign.left ? const Color(0xFF7C3AED) : Colors.white, onPressed: () => setState(() => _textAlign = TextAlign.left)),
            IconButton(icon: const Icon(Icons.format_align_center, size: 20), color: _textAlign == TextAlign.center ? const Color(0xFF7C3AED) : Colors.white, onPressed: () => setState(() => _textAlign = TextAlign.center)),
            IconButton(icon: const Icon(Icons.format_align_right, size: 20), color: _textAlign == TextAlign.right ? const Color(0xFF7C3AED) : Colors.white, onPressed: () => setState(() => _textAlign = TextAlign.right)),
            const VerticalDivider(width: 20, thickness: 1, color: Color(0xFF334155)),
            IconButton(icon: const Icon(Icons.format_clear, size: 20), color: Colors.white, onPressed: () => setState(() {_isBold = false; _isItalic = false; _isUnderline = false; _fontSize = 16; _textAlign = TextAlign.left;}), tooltip: 'Clear formatting'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _currentOverlay?.remove();
    _titleController.dispose();
    _contentController.dispose();
    _contentFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

// ==================== MODELS ====================
class DocumentSection {
  final String title;
  final int lineNumber;
  DocumentSection({required this.title, required this.lineNumber});
}

class _MenuSection {
  final List<_MenuItem> items;
  _MenuSection({required this.items});
}

class _MenuItem {
  final IconData icon;
  final String text;
  final String? shortcut;
  final bool hasSubmenu;
  final bool isChecked;
  final VoidCallback? onTap;
  _MenuItem({required this.icon, required this.text, this.shortcut, this.hasSubmenu = false, this.isChecked = false, this.onTap});
}

// ==================== LOGIN PAGE ====================
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.all(48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF7C3AED).withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.description_rounded, size: 72, color: Colors.white),
                ),
                const SizedBox(height: 32),
                const Text('BockDocs', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 12),
                const Text('Sign in to your account', style: TextStyle(fontSize: 18, color: Color(0xFF94A3B8))),
                const SizedBox(height: 56),
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Email address',
                    labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF7C3AED)),
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2)),
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF7C3AED)),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Color(0xFF94A3B8)),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2)),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Forgot password?', style: TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Sign In', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? ", style: TextStyle(color: Color(0xFF94A3B8))),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/signup'),
                      child: const Text('Sign Up', style: TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== SIGNUP PAGE ====================
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.all(48),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF9333EA)]),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Color(0xFF7C3AED).withOpacity(0.3), blurRadius: 20, offset: Offset(0, 10))],
                  ),
                  child: const Icon(Icons.description_rounded, size: 72, color: Colors.white),
                ),
                const SizedBox(height: 32),
                const Text('BockDocs', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 12),
                const Text('Create your account', style: TextStyle(fontSize: 18, color: Color(0xFF94A3B8))),
                const SizedBox(height: 56),
                _buildTextField(_nameController, 'Full Name', Icons.person_outline),
                const SizedBox(height: 24),
                _buildTextField(_emailController, 'Email address', Icons.email_outlined),
                const SizedBox(height: 24),
                _buildPasswordField(_passwordController, 'Password', _obscurePassword, () => setState(() => _obscurePassword = !_obscurePassword)),
                const SizedBox(height: 24),
                _buildPasswordField(_confirmPasswordController, 'Confirm Password', _obscureConfirmPassword, () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword)),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                    child: const Text('Create Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? ', style: TextStyle(color: Color(0xFF94A3B8))),
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Sign In', style: TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.w600))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
        prefixIcon: Icon(icon, color: Color(0xFF7C3AED)),
        filled: true,
        fillColor: const Color(0xFF1E293B),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2)),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label, bool obscure, VoidCallback toggle) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF7C3AED)),
        suffixIcon: IconButton(icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Color(0xFF94A3B8)), onPressed: toggle),
        filled: true,
        fillColor: const Color(0xFF1E293B),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2)),
      ),
    );
  }
}

// ==================== HOME PAGE ====================
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSidebarExpanded = false;
  List<Document> documents = [
    Document(id: '1', title: 'Untitled Document', lastModified: DateTime.now()),
    Document(id: '2', title: 'Meeting Notes', lastModified: DateTime.now().subtract(const Duration(days: 1))),
    Document(id: '3', title: 'Project Plan', lastModified: DateTime.now().subtract(const Duration(days: 2))),
    Document(id: '4', title: 'Budget Report', lastModified: DateTime.now().subtract(const Duration(days: 5))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _isSidebarExpanded ? 280 : 0,
            decoration: BoxDecoration(color: const Color(0xFF1E293B), border: Border(right: BorderSide(color: Color(0xFF334155)))),
            child: _isSidebarExpanded ? _buildSidebar() : null,
          ),
          Expanded(child: _buildMainContent()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/editor'),
        backgroundColor: const Color(0xFF7C3AED),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildSidebar() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF9333EA)]), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.description_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              const Text('BockDocs', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
            ],
          ),
        ),
        _buildSidebarItem(Icons.folder_rounded, 'BockDrive', true, null),
        _buildSidebarItem(Icons.settings_rounded, 'Settings', false, () => Navigator.pushNamed(context, '/settings')),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              CircleAvatar(radius: 32, backgroundColor: const Color(0xFF7C3AED), child: const Text('U', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600))),
              const SizedBox(height: 12),
              const Text('Demo User', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              const Text('demo@bockdocs.com', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarItem(IconData icon, String label, bool isSelected, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7C3AED).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFF7C3AED) : Colors.transparent),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFF94A3B8), size: 24),
            const SizedBox(width: 16),
            Text(label, style: TextStyle(color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFF94A3B8), fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(color: const Color(0xFF1E293B), border: Border(bottom: BorderSide(color: Color(0xFF334155)))),
          child: Row(
            children: [
              IconButton(icon: Icon(_isSidebarExpanded ? Icons.close : Icons.menu, color: Colors.white, size: 28), onPressed: () => setState(() => _isSidebarExpanded = !_isSidebarExpanded)),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(24), border: Border.all(color: Color(0xFF334155))),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search documents...',
                      hintStyle: const TextStyle(color: Color(0xFF64748B)),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              PopupMenuButton(
                icon: CircleAvatar(radius: 20, backgroundColor: const Color(0xFF7C3AED), child: const Text('U', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))),
                color: const Color(0xFF1E293B),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Row(children: const [Icon(Icons.settings_rounded, color: Color(0xFF94A3B8), size: 20), SizedBox(width: 12), Text('Settings', style: TextStyle(color: Colors.white))]),
                    onTap: () => Future.delayed(Duration.zero, () => Navigator.pushNamed(context, '/settings')),
                  ),
                  PopupMenuItem(
                    child: Row(children: const [Icon(Icons.logout, color: Colors.red, size: 20), SizedBox(width: 12), Text('Sign Out', style: TextStyle(color: Colors.red))]),
                    onTap: () => Future.delayed(Duration.zero, () => Navigator.pushReplacementNamed(context, '/login')),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Start a new document', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                      const SizedBox(height: 24),
                      InkWell(
                        onTap: () => Navigator.pushNamed(context, '/editor'),
                        child: Container(
                          width: 180,
                          height: 200,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF334155)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF7C3AED).withOpacity(0.7)]), borderRadius: BorderRadius.circular(16)),
                                child: Icon(Icons.add_rounded, size: 48, color: Colors.white),
                              ),
                              const SizedBox(height: 20),
                              Text('Blank Document', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(padding: const EdgeInsets.symmetric(horizontal: 40), child: const Divider(color: Color(0xFF334155))),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: const Text('Recent documents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
                const SizedBox(height: 24),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  itemCount: documents.length,
                  itemBuilder: (context, index) => _buildDocumentCard(documents[index], index),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentCard(Document doc, int index) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/editor'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF334155))),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFF7C3AED).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.description_rounded, color: Color(0xFF7C3AED), size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doc.title, style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text('Opened ${_getTimeAgo(doc.lastModified)}', style: const TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                ],
              ),
            ),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF94A3B8)),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Row(children: const [Icon(Icons.drive_file_rename_outline, color: Color(0xFF94A3B8), size: 20), SizedBox(width: 12), Text('Rename')]),
                  onTap: () => Future.delayed(Duration.zero, () => _showRenameDialog(doc, index)),
                ),
                PopupMenuItem(
                  child: Row(children: const [Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20), SizedBox(width: 12), Text('Remove', style: TextStyle(color: Colors.red))]),
                  onTap: () => setState(() => documents.removeAt(index)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showRenameDialog(Document doc, int index) {
    final controller = TextEditingController(text: doc.title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Rename Document', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF0F172A),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8)))),
          ElevatedButton(
            onPressed: () {
              setState(() => documents[index].title = controller.text);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED)),
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 0) return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    if (diff.inHours > 0) return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    return 'Just now';
  }
}

class Document {
  final String id;
  String title;
  final DateTime lastModified;
  Document({required this.id, required this.title, required this.lastModified});
}

// ==================== SETTINGS PAGE ====================
class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _nameController = TextEditingController(text: 'Demo User');
  final _emailController = TextEditingController(text: 'demo@bockdocs.com');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text('Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Account Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 24),
            Center(
              child: CircleAvatar(radius: 60, backgroundColor: const Color(0xFF7C3AED), child: const Text('U', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold))),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF7C3AED)),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF7C3AED)),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Settings updated'), backgroundColor: Colors.green));
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                child: const Text('Save Changes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 48),
            const Divider(color: Color(0xFF334155)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Sign Out', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.red)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red, width: 2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}