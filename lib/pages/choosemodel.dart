import 'package:flutter/material.dart';
import 'package:get/get.dart';

// --- Assume these imports exist ---
// Adjust paths as needed
import 'package:aicamera/controller/template.dart';
import 'package:aicamera/controller/piccore.dart';
// CategorySubController is not needed here as the list is passed
// import 'package:aicamera/controller/categorysub.dart';
import 'package:aicamera/models/template_entity.dart';
import 'package:aicamera/models/template_result_entity.dart';
// We receive the list directly, so the entity result model is needed for typing
import 'package:aicamera/models/category_sub_entity_result.dart';

// --- Import ChoosePrintPage ---
// Adjust path as needed
import 'chooseprint.dart';
// --- End of assumed imports ---

// Placeholder for default image
const String _defaultPlaceholderImage = 'https://placehold.co/300x400/eee/ccc?text=No+Img';

// --- ChooseModelPage: StatefulWidget accepting parameters ---
class ChooseModelPage extends StatefulWidget {
  final TemplateResultEntity selectedTemplate; // Initially selected template
  final String parentCategoryId; // ID of the parent category ("All")
  final String source; // Source parameter
  final List<CategorySubEntityResult> subCategories; // List of subcategories

  const ChooseModelPage({
    super.key,
    required this.selectedTemplate,
    required this.parentCategoryId,
    required this.source,
    required this.subCategories,
  });

  @override
  State<ChooseModelPage> createState() => _ChooseModelPageState();
}

class _ChooseModelPageState extends State<ChooseModelPage> {
  // --- Controllers ---
  // Use Get.find() as they should be initialized elsewhere
  final TemplateController _templateController = Get.find<TemplateController>();
  final PicCoreController _coreController = Get.find<PicCoreController>();

  // --- State Variables ---
  late TemplateResultEntity _currentTemplate; // Currently displayed template
  String? _selectedSubCategoryId; // Currently selected ID in the right nav
  bool _isTemplateLoading = false; // Loading state for template switching
  String? _templateErrorMessage; // Error message for template switching

  @override
  void initState() {
    super.initState();
    // Initialize with the passed template
    // Add null check just in case, although 'required' should prevent it.
    // If widget.selectedTemplate could be null, the design needs rethinking.
    _currentTemplate = widget.selectedTemplate;

    _selectedSubCategoryId = widget.parentCategoryId; // Default selection highlight
    _findInitialSelectedId();

  }

  // Helper to find which subcategory the initial template belongs to
  void _findInitialSelectedId() {
    // This logic depends heavily on your data structure.
    // Option 1: If TemplateResultEntity has a direct category/subcategory ID field:
    // Assuming TemplateResultEntity has a field like 'categoryId'
    // final String? templateCategoryId = widget.selectedTemplate.categoryId;
    // if (templateCategoryId != null && templateCategoryId.isNotEmpty) {
    //    // Check if it matches a subcategory ID
    //    final bool isSubCategory = widget.subCategories.any((sub) => sub.id == templateCategoryId);
    //    if (isSubCategory) {
    //      _selectedSubCategoryId = templateCategoryId;
    //      print("Found initial selected subcategory ID: $_selectedSubCategoryId");
    //      return; // Found it
    //    }
    //    // If it has a categoryId but doesn't match subcategories, maybe it's the parent?
    //    if (templateCategoryId == widget.parentCategoryId) {
    //       _selectedSubCategoryId = widget.parentCategoryId;
    //       print("Initial template belongs to parent category: $_selectedSubCategoryId");
    //       return; // Belongs to parent
    //    }
    // }

    // Fallback or default if no categoryId on template or no match found
    print("Initial template ID: ${widget.selectedTemplate.tplId}, Defaulting selected nav ID to parent: ${widget.parentCategoryId}");
    _selectedSubCategoryId = widget.parentCategoryId;

  }


  // --- Fetch ONE Template for a specific Category/SubCategory ID ---
  Future<void> _fetchAndSetTemplateForCategory(String categoryIdToFetch) async {
    // Avoid fetching if already selected AND not currently loading
    if (_selectedSubCategoryId == categoryIdToFetch && !_isTemplateLoading) return;

    if (!mounted) return;
    setState(() {
      _isTemplateLoading = true;
      _templateErrorMessage = null;
      // Keep the old template visible while loading.
    });

    try {
      print("Fetching ONE template for category/sub ID: $categoryIdToFetch with source: ${widget.source}");
      final templateRequest = TemplateEntity(
        source: widget.source,
        categorys: categoryIdToFetch,
        // page: 1, // Fetch only the first page
        // size: 1, // Fetch only one item
      );
      // Fetch templates - this updates _templateController.templateList
      await _templateController.fetchTemplates(templateRequest);

      if (!mounted) return;

      // **MODIFIED: Add null check for the first element**
      if (_templateController.templateList.isNotEmpty) {
        final TemplateResultEntity? firstTemplate = _templateController.templateList.first; // Use nullable type

        if (firstTemplate != null) { // Check if the first element is actually not null
          // Update the current template
          setState(() {
            _currentTemplate = firstTemplate; // Assign the non-null template
            _selectedSubCategoryId = categoryIdToFetch; // Update selected ID
            _isTemplateLoading = false;
          });
        } else {
          // Handle case where the list is not empty, but the first element is null (unexpected)
          print("Error: Fetched template list has null element at index 0 for category $categoryIdToFetch");
          setState(() {
            _isTemplateLoading = false;
            _templateErrorMessage = "获取到的模板数据无效"; // "Received invalid template data"
            _selectedSubCategoryId = categoryIdToFetch; // Still update selection visually
          });
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("获取 '${_getCategoryNameById(categoryIdToFetch)}' 的模板数据时出错")) // "Error getting template data for..."
          );
        }
      } else {
        // No template found for this subcategory
        setState(() {
          _isTemplateLoading = false;
          _templateErrorMessage = "未找到此分类的模板"; // "No template found for this category"
          _selectedSubCategoryId = categoryIdToFetch; // Still update selection visually
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("未找到 '${_getCategoryNameById(categoryIdToFetch)}' 的模板")) // "Template not found for..."
        );
      }
    } catch (e) {
      print("Error fetching template for category $categoryIdToFetch: $e");
      if (!mounted) return;
      setState(() {
        _isTemplateLoading = false;
        _templateErrorMessage = "加载模板失败: $e"; // "Failed to load template:"
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("加载 '${_getCategoryNameById(categoryIdToFetch)}' 模板时出错")) // "Error loading template for..."
      );
    }
  }

  // Helper to get category name for messages
  String _getCategoryNameById(String categoryId) {
    if (categoryId == widget.parentCategoryId) return "全部"; // "All"
    // Use firstWhereOrNull from GetX package (already imported)
    final sub = widget.subCategories.firstWhereOrNull((s) => s.id == categoryId);
    return sub?.name ?? categoryId; // Return name or ID if name not found
  }


  @override
  Widget build(BuildContext context) {
    // Adapt UI from choosemodel.dart, using _currentTemplate
    return Scaffold(
      // Use a consistent background color
      backgroundColor: const Color(0xFFE9E2FF), // Color from choosemodel.dart
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Align top for nav bar
          children: [
            // --- Main Content Area (Adapted from choosemodel.dart) ---
            Expanded(
              child: Column(
                children: [
                  // Top bar (Keep or modify as needed)
                  _buildTopBar(),
                  // Main image display area
                  _buildMainImageArea(),
                  const SizedBox(height: 16), // Spacing
                  // Thumbnail row (Remove or adapt based on new logic)
                  // _buildThumbnailRow(), // Commented out - likely not needed now
                  const SizedBox(height: 16), // Bottom spacing
                ],
              ),
            ),
            // --- Right SubCategory Navigation Bar ---
            _buildRightSubCategoryNavBar(),
          ],
        ),
      ),
    );
  }

  // --- UI Building Helper Methods ---

  Widget _buildTopBar() {
    // Copied and adapted from choosemodel.dart MyHomePage
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0, bottom: 16.0), // Added left padding
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Get.back(),
          ),
          const Text(
            '当前剩余可体验照片:', // "Currently remaining trial photos:"
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              '2张', // "2 photos" - TODO: Make dynamic if needed
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const Spacer(),
          const CircleAvatar( // TODO: Make dynamic if needed
            radius: 20,
            backgroundColor: Color(0xFF8A74FF),
            child: Text('125', style: TextStyle(color: Colors.white, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildMainImageArea() {
    // Displays the _currentTemplate image
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // --- Image Container ---
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0), // Added left padding
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AnimatedSwitcher( // Animate template changes
                duration: const Duration(milliseconds: 300),
                child: _isTemplateLoading // Show loading indicator OVER the image area
                    ? Container( // Use a container with background for loading
                  key: ValueKey('loading_${_selectedSubCategoryId}'), // Key for animation
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300, // Placeholder background
                    borderRadius: BorderRadius.circular(16),
                  ),
                  // Display current image semi-transparently below loading? Optional.
                  // child: Image.network( ... _currentTemplate.img ... opacity: 0.5),
                  child: const Center(child: CircularProgressIndicator()), // Simple loading spinner
                )
                    : Image.network( // Display the actual template image
                  // Use key to force rebuild on change
                    key: ValueKey(_currentTemplate.tplId ?? _currentTemplate.img), // Use tplId or img as key
                    _currentTemplate.img ?? _defaultPlaceholderImage,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, progress) {
                      // Can show progress indicator here too if image loading takes time
                      return progress == null ? child : const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      // Show error directly in the image area
                      return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.broken_image_outlined, color: Colors.grey, size: 40),
                                  SizedBox(height: 8),
                                  Text('无法加载图片', style: TextStyle(color: Colors.grey)), // "Cannot load image"
                                ],
                              )
                          )
                      );
                    }
                ),
              ),
            ),
          ),

          // --- Loading/Error Overlay (Removed as loading is handled by AnimatedSwitcher now) ---
          // if (_isTemplateLoading) ...

          // --- Display Error Message (if any) ---
          if (_templateErrorMessage != null && !_isTemplateLoading) // Show only if not loading
            Positioned(
              bottom: 80, // Adjust position
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _templateErrorMessage!,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),


          // --- Number Indicator (Top-Left) ---
          // TODO: Decide if this number should change based on template/category
          Positioned(
            left: 16, // Adjust for padding
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF8A74FF),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16)),
              ),
              child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),

          // --- "Select Photo" or "Use Template" Button (Bottom-Center) ---
          Positioned(
            bottom: 24,
            child: ElevatedButton(
              // Disable button if loading or if there was an error finding the template
              onPressed: (_isTemplateLoading || _templateErrorMessage != null) ? null : () {
                // Action when the main button is pressed
                print("选择照片/使用模板 button pressed for template: ${_currentTemplate.tplId}"); // "Select Photo / Use Template button pressed"
                // TODO: Implement action, e.g., navigate to photo selection or generation
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300, // Style for disabled state
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              // TODO: Change text based on context?
              child: const Text('点击选择照片', style: TextStyle(color: Colors.black, fontSize: 16)), // "Click to select photo"
            ),
          ),
        ],
      ),
    );
  }

  // --- Build Right SubCategory Navigation Bar ---
  // (Similar to SubCategoryPage, but uses widget.subCategories)
  Widget _buildRightSubCategoryNavBar() {
    // No separate loading state needed here as list is passed directly

    return Container(
      width: 60, // Fixed width
      // Use a slightly different background to distinguish from SubCategoryPage? Optional.
      color: Colors.black.withOpacity(0.15),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      // Use Column directly and add Spacer before the print button
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded( // Make the list scrollable and take available space
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // --- "All" Button ---
                  _buildVerticalNavButton(
                    label: "全部", // "All"
                    isSelected: _selectedSubCategoryId == widget.parentCategoryId,
                    onTap: () {
                      // Fetch the first template for the parent category ID
                      _fetchAndSetTemplateForCategory(widget.parentCategoryId);
                    },
                  ),
                  // --- SubCategory Buttons ---
                  ...widget.subCategories.map((subCategory) {
                    final dynamic subCatIdDynamic = subCategory.id;
                    String subCatId = '';
                    if (subCatIdDynamic is String) {
                      subCatId = subCatIdDynamic;
                    } else if (subCatIdDynamic != null) {
                      subCatId = subCatIdDynamic.toString();
                    }
                    if (subCatId.isEmpty) return const SizedBox.shrink();

                    return _buildVerticalNavButton(
                      label: subCategory.name ?? '未知', // "Unknown"
                      isSelected: _selectedSubCategoryId == subCatId,
                      onTap: () {
                        // Fetch the first template for this specific subcategory ID
                        _fetchAndSetTemplateForCategory(subCatId);
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          // --- Add "Go to Print" Button at the bottom ---
          _buildPrintButton(), // Add the print button here
          const SizedBox(height: 10), // Padding below print button
        ],
      ),
    );
  }

  // --- Helper: Build Print Button ---
  Widget _buildPrintButton() {
    return GestureDetector(
      onTap: () {
        // Use the ID from the *currently displayed* template
        final String? templateId = _currentTemplate.tplId;
        if (templateId != null && templateId.isNotEmpty) {
          print("前往打印 tapped from ChooseModelPage! Template ID: $templateId"); // "Go to print tapped"
          // TODO: Get the correct generationId if applicable
          // This likely needs to come from a state management solution or prior page result
          int generationId = 1; // Placeholder - needs actual ID if required by ChoosePrintPage
          Get.to(() => ChoosePrintPage(
            templateId: templateId,
            generationId: generationId, // Pass the actual generation ID
          ));
        } else {
          print("Error: Cannot navigate to print, template ID is missing for the current template.");
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("无法打印，当前模板信息不完整")) // "Cannot print, current template information incomplete"
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        decoration: BoxDecoration(
            color: const Color(0xFFEA4335), // Red color
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.red.withOpacity(0.3), spreadRadius: 1, blurRadius: 6, offset: Offset(0,2))
            ]
        ),
        child: const Column( // Vertical text
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('前', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)), // Go
            SizedBox(height: 5),
            Text('往', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)), // To
            SizedBox(height: 5),
            Text('打', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)), // Print
            SizedBox(height: 5),
            Text('印', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)), // (Action)
          ],
        ),
      ),
    );
  }


  // --- Helper Widget for Vertical Navigation Buttons ---
  // (Same as in SubCategoryPage)
  Widget _buildVerticalNavButton({required String label, required bool isSelected, required VoidCallback onTap}) {
    List<String> chars = label.split('');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple.withOpacity(0.8) : Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(18),
          boxShadow: isSelected ? [
            BoxShadow(color: Colors.deepPurple.withOpacity(0.5), spreadRadius: 1, blurRadius: 4, offset: Offset(0,1))
          ] : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: chars.map((char) => Text(
            char,
            style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                height: 1.2
            ),
          )).toList(),
        ),
      ),
    );
  }

// --- Helper Widget for Grid Item (Not used in this version) ---
// Widget _buildGridItem(...) { ... }

// --- Helper Widget for Thumbnails (Not used in this version) ---
// Widget _buildThumbnail(...) { ... }

}
