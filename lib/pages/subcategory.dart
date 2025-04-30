import 'package:flutter/material.dart';
import 'package:get/get.dart';

// --- Assume these imports exist ---
// Adjust paths as needed
import 'package:aicamera/controller/template.dart';
import 'package:aicamera/controller/piccore.dart';
import 'package:aicamera/controller/categorysub.dart'; // Added SubCategory Controller
import 'package:aicamera/models/template_entity.dart';
import 'package:aicamera/models/template_result_entity.dart';
import 'package:aicamera/models/category_sub_entity.dart'; // Added SubCategory Model
import 'package:aicamera/models/category_sub_entity_result.dart'; // Added SubCategory Result Model

// --- Import ChooseModelPage ---
// Adjust path as needed
import 'choosemodel.dart'; // Assuming choosemodel.dart defines ChooseModelPage

// --- End of assumed imports ---

// Placeholder for default image
const String _defaultPlaceholderImage = 'https://placehold.co/150x200/eee/ccc?text=No+Img';

// --- SubCategoryPage: Modified to include subcategory navigation ---
class SubCategoryPage extends StatefulWidget {
  final String source;
  final String categorys; // This is the PARENT category ID

  const SubCategoryPage({
    super.key,
    required this.source,
    required this.categorys,
  });

  @override
  State<SubCategoryPage> createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {
  // --- Controllers ---
  final TemplateController _templateController = Get.find<TemplateController>();
  final PicCoreController _coreController = Get.find<PicCoreController>();
  // Added CategorySubController
  final CategorySubController _categorySubController = Get.put(CategorySubController()); // Use put or find depending on lifecycle

  // --- State Variables ---
  bool _isTemplateLoading = true;
  String? _templateErrorMessage;
  bool _isSubCategoryLoading = true;
  String? _subCategoryErrorMessage;
  String? _selectedCategoryId; // Tracks the currently selected category/subcategory ID for fetching templates

  @override
  void initState() {
    super.initState();
    // Set the initial selected ID to the parent category ID
    _selectedCategoryId = widget.categorys;
    // Fetch initial data
    _fetchInitialData();
  }

  // --- Fetch Initial Data (Subcategories and Initial Templates) ---
  Future<void> _fetchInitialData() async {
    // Reset states
    if (!mounted) return;
    setState(() {
      _isTemplateLoading = true;
      _templateErrorMessage = null;
      _isSubCategoryLoading = true;
      _subCategoryErrorMessage = null;
    });

    // Fetch both concurrently
    await Future.wait([
      _fetchSubCategories(),
      _fetchTemplatesForCategory(widget.categorys), // Fetch initial templates for the parent category
    ]);

    // Ensure state is updated after fetches complete, even if one fails
    if (mounted) {
      setState(() {
        // Loading states are set individually within fetch methods
      });
    }
  }


  // --- Fetch SubCategories List ---
  Future<void> _fetchSubCategories() async {
    if (!mounted) return;
    // Don't reset loading here if called from fetchInitialData
    // setState(() { _isSubCategoryLoading = true; _subCategoryErrorMessage = null; });
    try {
      print("Fetching subcategories for category ID: ${widget.categorys}");
      final subCategoryRequest = CategorySubEntity(
        source: widget.source,
        categorys: widget.categorys, // Use the parent category ID
        // Add other necessary parameters if API requires them
      );
      await _categorySubController.fetchSubCategoryList(subCategoryRequest);
      if (!mounted) return;
      setState(() { _isSubCategoryLoading = false; });
    } catch (e) {
      print("Error fetching subcategories for category ${widget.categorys}: $e");
      if (!mounted) return;
      setState(() {
        _isSubCategoryLoading = false;
        _subCategoryErrorMessage = "加载子分类失败: $e"; // "Failed to load subcategories:"
      });
    }
  }


  // --- Fetch Templates for a specific Category/SubCategory ID ---
  // MODIFIED: Accepts categoryIdToFetch
  Future<void> _fetchTemplatesForCategory(String categoryIdToFetch) async {
    if (!mounted) return;
    // Set loading state specifically for templates
    setState(() {
      _isTemplateLoading = true;
      _templateErrorMessage = null;
      _selectedCategoryId = categoryIdToFetch; // Update selected ID
    });
    try {
      print("Fetching templates for category/sub ID: $categoryIdToFetch with source: ${widget.source}");
      final templateRequest = TemplateEntity(
        source: widget.source,
        categorys: categoryIdToFetch, // Use the passed ID
      );
      // Ensure the controller clears previous templates before fetching new ones
      // Note: Depending on your TemplateController implementation,
      // you might need to explicitly clear the list or handle pagination state.
      // Assuming fetchTemplates handles replacing/clearing the list.
      await _templateController.fetchTemplates(templateRequest);

      if (!mounted) return;
      setState(() {
        _isTemplateLoading = false;
        if (_templateController.templateList.isEmpty) {
          // Indicate no templates found in the UI instead of setting error message
        }
      });
    } catch (e) {
      print("Error fetching templates for category $categoryIdToFetch: $e");
      if (!mounted) return;
      setState(() {
        _isTemplateLoading = false;
        _templateErrorMessage = "加载模板失败: $e"; // "Failed to load templates:"
      });
    }
  }

  // --- Handle Template Item Tap ---
  // --- MODIFIED: Navigate to ChooseModelPage ---
  void _onTemplateTap(TemplateResultEntity template) {
    print("Tapped on template: ${template.title}, ID: ${template.tplId}");

    // Ensure subcategories are loaded before navigating
    if (_isSubCategoryLoading || _subCategoryErrorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("子分类信息仍在加载或加载失败，请稍候")) // "Subcategory info still loading or failed, please wait"
      );
      return;
    }

    // Navigate to ChooseModelPage
    Get.to(() => ChooseModelPage(
      // Pass the selected template
      selectedTemplate: template,
      // Pass the parent category ID
      parentCategoryId: widget.categorys,
      // Pass the source
      source: widget.source,
      // Pass the list of subcategories
      // Pass a copy to avoid modification issues if the controller updates the list
      subCategories: _categorySubController.subCategoryList.toList(),
    ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F7),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
        // TODO: Get category name if possible, otherwise use generic title
        title: const Text('选择模板'), // "Select Template"
      ),
      // MODIFIED: Use Row for layout
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Content Area (Template Grid)
          Expanded(
            child: _buildTemplateContentArea(),
          ),
          // Right Navigation Bar (SubCategory Buttons)
          _buildRightSubCategoryNavBar(),
        ],
      ),
    );
  }

  // --- Build Template Content Area (Left Side) ---
  Widget _buildTemplateContentArea() {
    if (_isTemplateLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_templateErrorMessage != null) {
      return Center( /* ... Error Display ... */
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 40),
              SizedBox(height: 16),
              Text(_templateErrorMessage!, textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
              SizedBox(height: 16),
              ElevatedButton(
                // Fetch templates for the currently selected category/sub category ID
                onPressed: () => _fetchTemplatesForCategory(_selectedCategoryId ?? widget.categorys),
                child: const Text('重试'), // "Retry"
              )
            ],
          ),
        ),
      );
    }

    // Display templates using Obx
    return Obx(() {
      // Check template list *after* loading and error checks
      if (_templateController.templateList.isEmpty) {
        return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("此分类下没有模板", style: TextStyle(color: Colors.grey)), // "No templates in this category"
            )
        );
      }
      // Build the grid using the templates from the controller
      return _buildTemplateGrid(_templateController.templateList);
    });
  }


  // --- Build the Template Grid ---
  Widget _buildTemplateGrid(List<TemplateResultEntity> templates) {
    // Added check for empty list just in case (Obx might handle it)
    if (templates.isEmpty) {
      return const Center(child: Text("没有可显示的模板")); // "No templates to display"
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.8,
            ),
            itemCount: templates.length,
            itemBuilder: (context, index) {
              final template = templates[index];
              return _buildGridItem(
                imageUrl: template.img ?? _defaultPlaceholderImage,
                text: template.title ?? '无标题模板', // "Untitled Template"
                // Pass the onTap handler for templates
                onTap: () => _onTemplateTap(template),
              );
            },
          ),
          const SizedBox(height: 24),
          const Row( /* ... Logo ... */
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.filter_vintage_rounded, size: 28, color: Colors.black54),
              SizedBox(width: 8),
              Text('乐玩幻镜', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54)), // Fun Mirror
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // --- Build Right SubCategory Navigation Bar ---
  Widget _buildRightSubCategoryNavBar() {
    if (_isSubCategoryLoading) {
      // Show a smaller loading indicator on the side
      return Container(
        width: 60, // Fixed width for the nav bar
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
      );
    }

    if (_subCategoryErrorMessage != null) {
      // Optionally show a small error indicator or retry button
      return Container(
        width: 60,
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Center(child: IconButton(icon: Icon(Icons.error_outline, color: Colors.red), onPressed: _fetchSubCategories)),
      );
    }

    // Use Obx to listen to subcategory list changes
    return Obx(() {
      final List<CategorySubEntityResult> subCategories = _categorySubController.subCategoryList;

      return Container(
        width: 60, // Fixed width
        color: Colors.black.withOpacity(0.1), // Subtle background
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: SingleChildScrollView( // Allow scrolling if many subcategories
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Align to top
            children: [
              // --- "All" Button ---
              _buildVerticalNavButton(
                label: "全部", // "All"
                isSelected: _selectedCategoryId == widget.categorys,
                onTap: () {
                  // Fetch templates for the parent category ID
                  _fetchTemplatesForCategory(widget.categorys);
                },
              ),
              // --- SubCategory Buttons ---
              ...subCategories.map((subCategory) {
                // **MODIFIED:** Add explicit type check and null/empty check
                final dynamic subCatIdDynamic = subCategory.id; // Assuming 'id' is the correct property name
                String subCatId = ''; // Default to empty string

                // Check the type and convert if necessary
                if (subCatIdDynamic is String) {
                  subCatId = subCatIdDynamic;
                } else if (subCatIdDynamic != null) {
                  // If it's not a String but not null, try converting it
                  subCatId = subCatIdDynamic.toString();
                  print("Warning: Subcategory ID was not a String, converted to: $subCatId");
                }

                // Check if empty after potential conversion
                if (subCatId.isEmpty) {
                  print("Warning: Skipping subcategory with empty ID. Name: ${subCategory.name}");
                  return const SizedBox.shrink(); // Skip if ID is invalid/empty
                }

                // Now use the validated subCatId
                return _buildVerticalNavButton(
                  label: subCategory.name ?? '未知', // "Unknown"
                  isSelected: _selectedCategoryId == subCatId,
                  onTap: () {
                    // Fetch templates for this specific subcategory ID
                    _fetchTemplatesForCategory(subCatId);
                  },
                );
              }).toList(),
            ],
          ),
        ),
      );
    }
    );
  }

  // --- Helper Widget for Vertical Navigation Buttons ---
  Widget _buildVerticalNavButton({required String label, required bool isSelected, required VoidCallback onTap}) {
    // Split label into individual characters for vertical display
    List<String> chars = label.split('');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        decoration: BoxDecoration(
          // Highlight selected button
          color: isSelected ? Colors.deepPurple.withOpacity(0.8) : Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(18), // Rounded corners
          boxShadow: isSelected ? [ // Add shadow to selected button
            BoxShadow(color: Colors.deepPurple.withOpacity(0.5), spreadRadius: 1, blurRadius: 4, offset: Offset(0,1))
          ] : [],
        ),
        child: Column( // Vertical text
          mainAxisSize: MainAxisSize.min,
          children: chars.map((char) => Text(
            char,
            style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                height: 1.2 // Adjust line height for vertical spacing
            ),
          )).toList(),
        ),
      ),
    );
  }


  // --- Helper Widget for Grid Item (Remains the same) ---
  Widget _buildGridItem({required String imageUrl, required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container( /* ... Item Styling ... */
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded( /* ... Image ... */
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0)
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) =>
                  (loadingProgress == null)
                      ? child
                      : Container(
                      color: Colors.grey.shade200,
                      child: Center(child: CircularProgressIndicator(strokeWidth: 2.0))
                  ),
                  errorBuilder: (context, error, stackTrace) =>
                      Container(
                          color: Colors.grey.shade200,
                          child: Center(child: Icon(Icons.image_not_supported_outlined, color: Colors.grey.shade400))
                      ),
                ),
              ),
            ),
            Padding( /* ... Text ... */
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.black87),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
