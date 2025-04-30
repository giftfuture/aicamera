import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math'; // For Random placeholder if needed

// --- Controller Imports ---
// Adjust paths as needed
import 'package:aicamera/controller/template.dart';
// Removed PicCoreController import
// import 'package:aicamera/controller/piccore.dart';

// --- Model Imports ---
// Adjust paths as needed
import 'package:aicamera/models/template_entity.dart';
import 'package:aicamera/models/template_result_entity.dart';
import 'package:aicamera/models/category_sub_entity_result.dart'; // For subCategory type

// --- Page Imports ---
// Adjust path as needed
import 'chooseprint.dart';

// Placeholder for default image
const String _defaultPlaceholderImage = 'https://placehold.co/300x400/eee/ccc?text=No+Preview';

// --- ChooseModelPage: StatefulWidget accepting parameters ---
class ChooseModelPage extends StatefulWidget {
  // *** Renamed parameter from initialTemplate to selectedTemplate ***
  final TemplateResultEntity selectedTemplate; // Initially selected template to display
  final String parentCategoryId; // ID of the parent category ("All") - Ensure this is String
  final String source; // Source parameter
  final List<CategorySubEntityResult> subCategories; // List of subcategories passed from previous page

  const ChooseModelPage({
    super.key,
    // *** Updated parameter name in constructor ***
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
  // Find controllers - Ensure they are put() before this page loads (e.g., in Bindings)
  final TemplateController _templateController = Get.find<TemplateController>();
  // *** REMOVED PicCoreController instance ***
  // final PicCoreController _coreController = Get.find<PicCoreController>();

  // --- State Variables ---
  // Currently selected/displayed template in the main view
  late Rx<TemplateResultEntity> _currentTemplate;
  // ID of the subcategory whose templates are shown in the bottom carousel
  late RxnString _selectedSubCategoryIdForTemplates;
  // Scroll controller for the template list
  final ScrollController _templateScrollController = ScrollController();
  // Scroll controller for the vertical subcategory list
  final ScrollController _subCategoryScrollController = ScrollController();


  // --- UI Constants ---
  final double _templateListHeight = 120.0; // Height for the bottom template list
  final double _printButtonWidth = 50.0; // Define a width for the print button column
  final double _subCategoryListWidth = 60.0; // Define a width for the vertical subcategory list

  @override
  void initState() {
    super.initState();
    // *** Initialize with the updated parameter name: widget.selectedTemplate ***
    _currentTemplate = Rx<TemplateResultEntity>(widget.selectedTemplate);

    // Determine the initial subcategory ID to fetch templates for
    // Start by fetching templates for the "All" category (parent)
    _selectedSubCategoryIdForTemplates = RxnString(widget.parentCategoryId);
    // Use try-catch for initial fetch
    _fetchTemplatesSafely(widget.parentCategoryId);
  }

  @override
  void dispose() {
    _templateScrollController.dispose();
    _subCategoryScrollController.dispose(); // Dispose the new scroll controller
    super.dispose();
  }

  // --- Fetch Templates Safely ---
  Future<void> _fetchTemplatesSafely(String subCategoryId) async {
    try {
      await _fetchTemplatesForSubCategory(subCategoryId);
    } catch (e) {
      print("Error fetching templates for $subCategoryId: $e");
      Get.snackbar(
        "加载错误", // Title: "Loading Error"
        "无法加载 '$subCategoryId' 的模板", // Message: "Could not load templates for '$subCategoryId'"
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white,
      );
    }
  }


  // --- Fetch Templates for the selected SubCategory ID ---
  Future<void> _fetchTemplatesForSubCategory(String subCategoryId) async {
    print("Fetching templates for subcategory ID: $subCategoryId");
    _selectedSubCategoryIdForTemplates.value = subCategoryId;
    _templateController.clearTemplates(); // Clear previous templates

    final templateRequest = TemplateEntity(
      source: widget.source,
      categorys: subCategoryId, // Assuming 'categorys' is the correct field name for the request
    );
    await _templateController.fetchTemplates(templateRequest);
  }

  // --- Handle Template Selection from Carousel ---
  void _onTemplateSelected(TemplateResultEntity template) {
    // *** UPDATED Line 118: Changed template.name to template.title ***
    print("Template selected from carousel: ${template.title ?? 'Unknown'} (ID: ${template.tplId})");
    if (mounted && _currentTemplate.value.tplId != template.tplId) {
      _currentTemplate.value = template; // Update the main display
    }
  }


  @override
  Widget build(BuildContext context) {
    // !!! IMPORTANT: Ensure necessary controllers (like TemplateController) are initialized globally BEFORE this page loads !!!

    // Main layout with Row: Print Button | Center Content | Vertical SubCategory List
    return Scaffold(
      backgroundColor: const Color(0xFFE9E2FF), // Background color
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Align top for buttons/lists
          children: [
            // --- Vertical "Go to Print" Button (Left Side) ---
            SizedBox(
              width: _printButtonWidth,
              // *** Wrap the button content in Center for vertical alignment ***
              child: Center(
                child: _buildPrintButton(context), // Pass context for ScaffoldMessenger
              ),
            ),

            // --- Main Content Area (Center) ---
            Expanded(
              child: Column( // Center area is a column
                children: [
                  // Top bar
                  _buildTopBar(),
                  const SizedBox(height: 10), // Spacing
                  // Main image display area (Takes remaining vertical space)
                  Expanded(child: _buildMainImageArea()),
                  // Template Carousel (Bottom)
                  _buildTemplateCarousel(),
                ],
              ),
            ),

            // --- Vertical SubCategory List (Right Side) ---
            SizedBox(
              width: _subCategoryListWidth,
              child: _buildVerticalSubCategoryList(),
            ),
          ],
        ),
      ),
    );
  }
  // --- UI Building Helper Methods ---

  Widget _buildPrintButton(BuildContext scaffoldContext) {
    // Button appearance is static, no Obx needed here
    return Padding(
      // Removed top padding to allow Center widget to work correctly
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        onTap: () {
          // Read the reactive value directly when tapped
          final String? templateId = _currentTemplate.value.tplId;
          if (templateId != null && templateId.isNotEmpty) {
            print("前往打印 tapped! Template ID: $templateId"); // "Go to print tapped"
            // Navigate to ChoosePrintPage, passing the selected template ID
            Get.to(() => ChoosePrintPage(
              templateId: templateId,
            ));
          } else {
            print("Error: Cannot navigate to print, template ID is missing.");
            // Use ScaffoldMessenger safely
            ScaffoldMessenger.maybeOf(scaffoldContext)?.showSnackBar(
                const SnackBar(content: Text("请先选择一个模板"), duration: Duration(seconds: 2)) // "Please select a template first"
            );
          }
        },
        child: Container(
          // Width is constrained by the parent SizedBox now
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 5.0), // Adjusted padding
          decoration: BoxDecoration(
              color: const Color(0xFFEA4335), // Red color
              borderRadius: BorderRadius.circular(18), // Slightly adjusted radius
              boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.3), spreadRadius: 1, blurRadius: 6, offset: Offset(0, 2))]
          ),
          child: const Column( // Vertical text
            mainAxisSize: MainAxisSize.min, // Fit content height
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('前', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)), SizedBox(height: 4), // Go
              Text('往', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)), SizedBox(height: 4), // To
              Text('打', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)), SizedBox(height: 4), // Print
              Text('印', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)), // (Action)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    // Top bar with back button ONLY now
    return Padding(
      // Adjusted padding
      padding: const EdgeInsets.only(left: 8.0, top: 16.0, right: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            iconSize: 20,
            onPressed: () => Get.back(),
            tooltip: "返回", // Back
          ),
          // You can add a title here if needed, e.g., using _currentTemplate.value.name
          // Expanded(
          //   child: Obx(() => Text(
          //       _currentTemplate.value.name ?? "选择模板",
          //       textAlign: TextAlign.center,
          //       overflow: TextOverflow.ellipsis,
          //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          //     )),
          // ),
          // Add a spacer or adjust alignment if you add a title
          const Spacer(),
          // Placeholder for potential right-side actions if needed later
          SizedBox(width: 40) // Maintain similar spacing as IconButton
        ],
      ),
    );
  }

  // --- Vertical SubCategory List (Right Side) ---
  Widget _buildVerticalSubCategoryList() {
    // List includes "All" plus passed subcategories
    final List<CategorySubEntityResult> categoriesToShow = [
      // ** Use the correct ID field and type from CategorySubEntityResult **
      // Assuming 'id' is int? and 'name' is String?
      CategorySubEntityResult(id: int.tryParse(widget.parentCategoryId), name: "全部"), // "All"
      ...widget.subCategories
    ];

    return Container(
      // Width is set by parent SizedBox
      padding: const EdgeInsets.only(top: 16.0, left: 4.0, right: 4.0), // Padding for the list
      child: ListView.builder(
        controller: _subCategoryScrollController, // Attach scroll controller
        itemCount: categoriesToShow.length,
        itemBuilder: (context, index) {
          final subCategory = categoriesToShow[index];
          // *** Use the correct ID field from CategorySubEntityResult (e.g., id, categorys) ***
          final String? subCatId = subCategory.id?.toString();
          if (subCatId == null || subCatId.isEmpty) {
            print("Warning: Subcategory at index $index has invalid ID.");
            return const SizedBox.shrink(); // Skip invalid items
          }

          // Use Obx to reactively update selection style
          return Obx(() {
            final bool isSelected = _selectedSubCategoryIdForTemplates.value == subCatId;
            // Build the vertical button/chip for each subcategory
            return _buildVerticalNavButton(
              label: subCategory.name ?? '未知', // Use name for label
              isSelected: isSelected,
              onTap: () {
                if (!isSelected) {
                  _fetchTemplatesSafely(subCatId); // Use safe fetch
                }
              },
            );
          });
        },
      ),
    );
  }

  // --- Helper for Vertical Navigation Buttons ---
  Widget _buildVerticalNavButton({required String label, required bool isSelected, required VoidCallback onTap}) {
    // Split label into characters for vertical display
    List<String> chars = label.split('');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Width is constrained by parent SizedBox
        margin: const EdgeInsets.symmetric(vertical: 6.0), // Vertical spacing
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0), // Internal padding
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple.withOpacity(0.8) : Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(18),
          boxShadow: isSelected ? [
            BoxShadow(color: Colors.deepPurple.withOpacity(0.5), spreadRadius: 1, blurRadius: 4, offset: Offset(0,1))
          ] : [],
        ),
        child: Column( // Arrange characters vertically
          mainAxisSize: MainAxisSize.min, // Fit content height
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


  Widget _buildMainImageArea() {
    // Obx listens to changes in _currentTemplate to update the image
    return Obx(() => Padding(
      // Adjusted padding to fit between button and vertical list
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0),
      child: ClipRRect( // Clip image to rounded corners
        borderRadius: BorderRadius.circular(16),
        child: Container( // Background container for loading/error states
          decoration: BoxDecoration(
            color: Colors.grey.shade300, // Background color
            borderRadius: BorderRadius.circular(16),
          ),
          width: double.infinity, // Ensure container takes full width within Expanded
          height: double.infinity, // Ensure container takes full height within Expanded
          // Use FittedBox to ensure the AnimatedSwitcher and Image respect the bounds
          child: FittedBox(
            fit: BoxFit.contain, // Contain the image within the bounds
            alignment: Alignment.center, // Center the image
            child: AnimatedSwitcher( // Smooth transition between images
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child); // Fade transition
              },
              child: Image.network(
                // *** Use the correct image field from TemplateResultEntity (e.g., img, preview) ***
                  _currentTemplate.value.img ?? _defaultPlaceholderImage, // Assuming 'img' field
                  // Use template ID as key for AnimatedSwitcher to detect change
                  key: ValueKey(_currentTemplate.value.tplId ?? _currentTemplate.value.img ?? DateTime.now().millisecondsSinceEpoch), // More robust key
                  // Removed explicit width/height, rely on FittedBox
                  // Loading builder displays progress indicator
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child; // Show image when loaded
                    return SizedBox( // Give placeholder a size during loading
                      width: 100, // Example size, adjust as needed
                      height: 150,
                      child: Center(child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                            : null,
                      )),
                    );
                  },
                  // Error builder displays an error icon and message
                  errorBuilder: (context, error, stackTrace) {
                    print("Error loading image: ${_currentTemplate.value.img} - $error"); // Log error using correct field
                    return const SizedBox( // Give placeholder a size on error
                      width: 100,
                      height: 150,
                      child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image_outlined, color: Colors.grey, size: 40), // Smaller icon
                              SizedBox(height: 4),
                              Text('无法加载', style: TextStyle(color: Colors.grey, fontSize: 12)), // "Cannot load"
                            ],
                          )
                      ),
                    );
                  }
              ),
            ),
          ),
        ),
      ),
    )
    );
  }


  // --- Template Carousel (Bottom) ---
  Widget _buildTemplateCarousel() {
    // Obx listens to TemplateController's state (isLoading, templateList)
    return Obx(() {
      final bool isLoading = _templateController.isLoading.value;
      final List<TemplateResultEntity> templates = _templateController.templateList;

      // Show loading indicator while fetching templates
      if (isLoading && templates.isEmpty) {
        return Container(
          height: _templateListHeight, // Use defined height
          child: const Center(child: CircularProgressIndicator()),
        );
      }

      // Show message if no templates are found for the selected subcategory
      if (!isLoading && templates.isEmpty) {
        return Container(
          height: _templateListHeight, // Use defined height
          alignment: Alignment.center,
          child: Text("未找到模板", style: TextStyle(color: Colors.grey.shade600)), // "No templates found"
        );
      }

      // Build the horizontal list view for templates
      return Container(
        height: _templateListHeight, // Use defined height
        color: Colors.black.withOpacity(0.1), // Subtle background for the carousel
        padding: const EdgeInsets.symmetric(vertical: 8.0), // Vertical padding
        child: ListView.builder(
          controller: _templateScrollController, // Attach scroll controller
          scrollDirection: Axis.horizontal, // Make it scroll horizontally
          itemCount: templates.length,
          itemBuilder: (context, index) {
            final template = templates[index];
            // Check if this template is the one currently displayed in the main area
            final bool isSelected = _currentTemplate.value.tplId == template.tplId;

            // Build each template item
            return GestureDetector(
              onTap: () => _onTemplateSelected(template), // Handle tap event
              child: Container(
                width: _templateListHeight * 0.75, // Width relative to height for aspect ratio
                margin: EdgeInsets.only( // Add horizontal margin for spacing
                  left: index == 0 ? 16.0 : 8.0, // More padding for the first item
                  right: index == templates.length - 1 ? 16.0 : 8.0, // More padding for the last item
                ),
                decoration: BoxDecoration( // Styling for the template item
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  border: isSelected // Highlight selected item with a border
                      ? Border.all(color: Colors.deepPurpleAccent, width: 3.0)
                      : Border.all(color: Colors.grey.shade400, width: 1.0), // Default border
                  boxShadow: isSelected ? [ // Add shadow to selected item
                    BoxShadow(color: Colors.deepPurple.withOpacity(0.4), blurRadius: 5, spreadRadius: 1)
                  ] : [],
                ),
                clipBehavior: Clip.antiAlias, // Clip the image inside
                child: Image.network( // Display template preview image
                  // *** Use the correct image field from TemplateResultEntity (e.g., img, preview) ***
                  template.img ?? _defaultPlaceholderImage, // Assuming 'img' field
                  fit: BoxFit.cover, // Cover the container area
                  // Show loading indicator while image loads
                  loadingBuilder: (context, child, progress) {
                    return progress == null ? child : Center(child: CircularProgressIndicator(strokeWidth: 2.0));
                  },
                  // Show error icon if image fails to load
                  errorBuilder: (context, error, stack) {
                    return const Center(child: Icon(Icons.error_outline, color: Colors.grey));
                  },
                ),
              ),
            );
          },
        ),
      );
    });
  }

} // End of _ChooseModelPageState

// --- Placeholder PicCoreController ---
// Replace with your actual controller implementation
// *** REMOVED PicCoreController Definition - Ensure it exists elsewhere if needed ***
// class PicCoreController extends GetxController { ... }
