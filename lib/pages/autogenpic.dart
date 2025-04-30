import 'package:aicamera/pages/subcategory.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math'; // Import for Random

// --- Controller Imports ---
import 'package:aicamera/controller/category.dart';
import 'package:aicamera/controller/categorysub.dart';
import 'package:aicamera/controller/template.dart';

// --- Page Imports ---
import '../controller/autogenpic.dart';
import '../controller/piccore.dart';
import 'choosemodel.dart';
import 'chooseprint.dart';

// --- Entity Model Imports ---
import 'package:aicamera/models/category_entity.dart';
import 'package:aicamera/models/category_entity_result.dart';
import 'package:aicamera/models/category_sub_entity.dart';
import 'package:aicamera/models/category_sub_entity_result.dart';
import 'package:aicamera/models/template_entity.dart';
import 'package:aicamera/models/template_result_entity.dart';
import 'package:aicamera/models/autogenpic_entity.dart'; // Adjust path if needed



// --- AutoGenPicPage: Now returns the actual page content directly ---
class AutoGenPicPage extends StatelessWidget {

  final String insUrl; // Input image URL
  final int? sex;    // Input gender (e.g., "0" or "1")
  final String source = '14';
  const AutoGenPicPage({super.key, required this.insUrl, this.sex});

  @override
  Widget build(BuildContext context) {
    // --- Controller Initialization ---
    // Ensure controllers are initialized. Using Get.put here is okay if this page
    // is the primary entry point for these controllers and they aren't needed before.
    // However, using Bindings is generally preferred for better organization.
    Get.put(CategoryController());
    Get.put(CategorySubController());
    Get.put(TemplateController());
    Get.put(AutoGenPicController());
    Get.put(PicCoreController());
    // Ensure CoreController is initialized ONCE elsewhere (e.g., main.dart or bindings)
    // Get.put(CoreController(), permanent: true); // DON'T put CoreController here if it's global

    // *** REMOVED GetMaterialApp wrapper ***
    // Return the MyHomePage directly. It will be built within the context
    // of the main GetMaterialApp defined at the root of your application.
    // MyHomePage itself contains the Scaffold.
    return MyHomePage(insUrl: insUrl, sex: sex);
  }
}

// --- MyHomePage: Contains the Scaffold and main page logic ---
class MyHomePage extends StatefulWidget {
  final String insUrl;
  final int? sex;

  const MyHomePage({super.key, required this.insUrl, this.sex});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // --- Controllers ---
  // Use Get.find() because they should have been put() in AutoGenPicPage's build method
  // or preferably in Bindings before this page was routed to.
  final CategoryController _categoryController = Get.find<CategoryController>();
  final CategorySubController _categorySubController = Get.find<CategorySubController>();
  final TemplateController _templateController = Get.find<TemplateController>();
  final AutoGenPicController _autoGenPicController = Get.find<AutoGenPicController>();
  final PicCoreController _coreController = Get.find<PicCoreController>(); // Find the global CoreController


  // --- State Variables ---
  bool _isLoading = true; // Tracks initial data loading sequence
  TemplateResultEntity? _selectedTemplate;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchRandomDataSequence();
  }

  // --- Data Fetching Logic ---
  Future<void> _fetchRandomDataSequence() async {
    // Reset state only if not already loading to avoid unnecessary rebuilds
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _selectedTemplate = null; // Clear previous template
        _autoGenPicController.clearState(); // Clear generation state too
      });
    } else {
      // If already loading (e.g., during initState), just ensure error is null
      _errorMessage = null;
      _selectedTemplate = null;
      _autoGenPicController.clearState();
    }


    try {
      // Step 1: Fetch Category List and select a random one
      print("--- Step 1: Fetching category list... ---");
      final categoryRequest = CategoryEntity(
          source: '14', // Replace with actual source
          deviceId: _coreController.deviceId,
          zone: "0", // Replace with actual zone
          versionType:"1", // Replace with actual versionType
          sex: widget.sex ?? 0
      );
      await _categoryController.fetchMenuList(categoryRequest);

      final List<CategoryEntityResult> categories = _categoryController.menuList;
      if (categories.isEmpty) {
        throw Exception("未能获取分类列表");
      }
      final CategoryEntityResult randomCategory = categories[_coreController.random.nextInt(categories.length)];
      final String? categoryId = randomCategory.categorys;
      if (categoryId == null || categoryId.isEmpty) {
        throw Exception("获取到的随机分类缺少ID");
      }
      print("Selected Category ID: $categoryId, Name: ${randomCategory.name}");


      // Step 2: Fetch SubCategory List
      print("--- Step 2: Fetching subcategory list for category ID: $categoryId... ---");
      final subCategoryRequest = CategorySubEntity(source: '14', categorys: categoryId);
      await _categorySubController.fetchSubCategoryList(subCategoryRequest);

      final List<CategorySubEntityResult> subCategories = _categorySubController.subCategoryList;
      if (subCategories.isEmpty) {
        throw Exception("未能获取子分类列表 (分类ID: $categoryId)");
      }
      final CategorySubEntityResult randomSubCategory = subCategories[_coreController.random.nextInt(subCategories.length)];
      final String? subCategoryId = categoryId;
      if (subCategoryId == null || subCategoryId.isEmpty) {
        throw Exception("获取到的随机子分类缺少ID");
      }
      print("Selected SubCategory ID: $subCategoryId, Name: ${randomSubCategory.name}");


      // Step 3: Fetch Template List and select a random one
      print("--- Step 3: Fetching template list for subcategory ID: $subCategoryId... ---");
      final templateRequest = TemplateEntity(source: '14', categorys: subCategoryId);
      // Use the controller's method which handles pagination internally
      await _templateController.fetchTemplates(templateRequest);

      final List<TemplateResultEntity> templates = _templateController.templateList;
      if (templates.isEmpty) {
        throw Exception("未能获取模板列表 (子分类ID: $subCategoryId)");
      }
      final TemplateResultEntity randomTemplate = templates[_coreController.random.nextInt(templates.length)];
      final String? selectedTplId = randomTemplate.tplId;
      if (selectedTplId == null || selectedTplId.isEmpty) {
        throw Exception("获取到的随机模板缺少tplId");
      }
      print("Selected Template ID (tplId): $selectedTplId, Name: ${randomTemplate.tplId}");
      print("Selected Template Preview URL: ${randomTemplate.img}");


      // Step 3.5: Call AutoGenPicController.generatePicture
      print("--- Step 3.5: Calling generatePicture... ---");
      final autoGenRequest = AutoGenPicEntity(
        img: widget.insUrl,
        tplid: selectedTplId,
        sex: widget.sex ?? 0,
        source: '14', // Replace with actual source
        deviceId: _coreController.deviceId,
      );

      // Call generatePicture - No need to await if we show loading via Obx
      // Awaiting here makes the whole sequence wait for generation.
      // Let's trigger it and let the Obx handle the loading state.
      _autoGenPicController.generatePicture(autoGenRequest); // Don't await here

      // Store the selected template *before* checking generation result,
      // so the UI can display the template while generation happens.
      setState(() {
        _selectedTemplate = randomTemplate;
        _isLoading = false; // Mark initial sequence loading as done
      });

      // We will rely on Obx in buildBody to show generation loading/error


    } catch (e, stackTrace) {
      print("Error during data fetch sequence: $e");
      print("Stack trace: $stackTrace");
      setState(() {
        _errorMessage = "加载数据时出错: $e";
        _isLoading = false; // Stop loading on error
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    // *** The Scaffold is now the root of MyHomePage ***
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F7),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          // Use Get.back() for navigation if your root is GetMaterialApp
          onPressed: () => Get.back(),
        ),
        backgroundColor: const Color(0xFFF0F0F7),
        title: const Text(
          '已为您自动生成一张',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: _buildBody(), // Body content remains the same
    );
  }

  // --- Body Building Logic ---
  Widget _buildBody() {
    // Use Obx to listen to AutoGenPicController's loading/error state
    return Obx(() {
      // Show initial loading indicator if the sequence is still running
      if (_isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      // Show error from the initial sequence
      else if (_errorMessage != null) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 48),
                SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: Icon(Icons.refresh),
                  label: Text("重试"), // "Retry"
                  onPressed: _fetchRandomDataSequence, // Retry the whole sequence
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      }
      // Show selected template content (even while generating)
      else if (_selectedTemplate != null) {
        // Show the main content, potentially overlaying a loading indicator for generation
        return Stack( // Use Stack to overlay loading indicator
          children: [
            _buildMainContent(), // Build the main content with the selected template
            // Show generation loading indicator if generating
            if (_autoGenPicController.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.3), // Semi-transparent overlay
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text("正在生成图片...", style: TextStyle(fontSize: 16, color: Colors.white)), // "Generating image..."
                    ],
                  ),
                ),
              ),
            // Show generation error if generation failed AFTER initial load succeeded
            if (_autoGenPicController.errorMessage.value != null)
              Container(
                color: Colors.black.withOpacity(0.7), // Darker overlay for error
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 40),
                        SizedBox(height: 16),
                        Text(
                          "图片生成失败:\n${_autoGenPicController.errorMessage.value}", // "Image generation failed"
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        // Optional: Add a button to retry only the generation step
                        ElevatedButton(
                          onPressed: () {
                            // Retry only the generation step
                            if (_selectedTemplate?.tplId != null) {
                              final autoGenRequest = AutoGenPicEntity(
                                img: widget.insUrl,
                                tplid: _selectedTemplate!.tplId!,
                                sex: widget.sex ?? 0,
                                source: '14',
                                deviceId: _coreController.deviceId,
                              );
                              _autoGenPicController.generatePicture(autoGenRequest);
                            }
                          },
                          child: Text("重试生成"), // "Retry Generation"
                        )
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      }
      // Fallback if no template selected and no error/loading
      else {
        return const Center(child: Text("未能加载模板数据 (Could not load template data)"));
      }
    }); // End Obx
  }

  // --- Main Content Widget ---
  Widget _buildMainContent() {
    // Use the fetched template data (_selectedTemplate which is TemplateResultEntity)
    String imageUrl = _selectedTemplate?.img ?? 'https://placehold.co/400x400/eee/ccc?text=No+Preview';
    String templateName = _selectedTemplate?.title ?? '未知模板';

    // This builds the main UI part, it's called by _buildBody when appropriate
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16.0, right: 8.0, top: 16.0, bottom: 16.0),
            child: Column(
              children: [
                // --- Display Fetched Template Image ---
                Container( /* ... Image display ... */
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey.shade300)
                  ),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width * 0.8,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) { /* ... */
                      if (loadingProgress == null) return child;
                      return Container(
                        height: MediaQuery.of(context).size.width * 0.8,
                        color: Colors.grey.shade200,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 2.0,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container( /* ... */
                      height: MediaQuery.of(context).size.width * 0.8,
                      color: Colors.grey.shade200,
                      child: Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image_outlined, color: Colors.grey.shade400, size: 40),
                          SizedBox(height: 8),
                          Text('无法加载图片', style: TextStyle(color: Colors.grey.shade600)),
                        ],
                      )),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(templateName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                // --- Recommendation Bar ---
                Container( /* ... Recommendation Bar ... */
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.0),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.withOpacity(0.15), spreadRadius: 1, blurRadius: 4, offset: Offset(0,2))
                      ]
                  ),
                  child: InkWell(
                    onTap: () => Get.to(() => ChooseModelPage()),
                    borderRadius: BorderRadius.circular(24.0),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome_outlined, size: 18, color: Colors.deepPurple),
                          SizedBox(width: 8),
                          Text('查看更多可选的类型', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // --- Grid view for OTHER categories/styles ---
                Obx(() { /* ... GridView ... */
                  if (_categoryController.isMenuLoading.value && _categoryController.menuList.isEmpty) {
                    return GridView.count( /* ... Shimmer Grid ... */
                      crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.8,
                      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(4, (index) => _buildGridItemShimmer()),
                    );
                  }
                  if (_categoryController.menuList.isEmpty && !_categoryController.isMenuLoading.value) {
                    return const Center(child: Text("未找到分类", style: TextStyle(color: Colors.grey)));
                  }
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.8,
                    ),
                    itemCount: _categoryController.menuList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final category = _categoryController.menuList[index];
                      // MODIFIED: Pass onTap callback to _buildGridItem
                      return _buildGridItem(
                        category.img ?? 'https://placehold.co/150x200/eee/ccc?text=No+Img',
                        category.name ?? '加载中...', // Loading...
                            () { // onTap callback function
                          final String? categoryId = category.categorys;
                          final String categoryName = category.name ?? '子分类'; // Subcategory

                          if (categoryId != null && categoryId.isNotEmpty) {
                            print("Navigating to SubCategoryPage for category ID: $categoryId, Name: $categoryName");
                            // --- Navigation Logic ---
                            // Ensure SubCategoryPage is imported at the top of autogenpic.dart
                            // import 'path/to/subcategory.dart'; // Adjust the path
                            Get.to(() => SubCategoryPage(
                              source: '14',
                              categorys: categoryId
                            ));
                            // --- End Navigation Logic ---
                          } else {
                            print("Error: Category ID is null or empty for ${category.name}");
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("无法导航：分类ID无效")) // Cannot navigate: Invalid category ID
                            );
                          }
                        },
                      );
                    },
                  );
                }),
                const SizedBox(height: 24),

                // --- Bottom Logo ---
                const Row( /* ... Logo ... */
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.filter_vintage_rounded, size: 28, color: Colors.black54),
                    SizedBox(width: 8),
                    Text('乐玩幻镜', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54)),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        // --- Vertical "Go to Print" Button ---
        Padding( /* ... Print Button ... */
          padding: const EdgeInsets.only(top: 16.0, right: 8.0),
          child: GestureDetector(
            onTap: () {
              final resultId = _autoGenPicController.generationResult.value?.id;
              if (_selectedTemplate?.tplId != null && resultId != null) {
                Get.to(() => ChoosePrintPage(
                  templateId: _selectedTemplate!.tplId!,
                  generationId: resultId,
                ));
              } else if (_selectedTemplate?.tplId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("无法获取模板ID"))
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("图片生成未完成或失败"))
                );
              }
            },
            child: Container( /* ... Button Style ... */
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
              decoration: BoxDecoration(
                  color: const Color(0xFFEA4335),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [ BoxShadow(color: Colors.red.withOpacity(0.3), spreadRadius: 1, blurRadius: 6, offset: Offset(0,2)) ]
              ),
              child: const Column( /* ... Button Text ... */
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('前', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text('往', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text('打', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text('印', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }


  // --- Helper Widgets (Grid Item, Shimmer) ---
  Widget _buildGridItem(String imageUrl, String text, VoidCallback onTap) {
    return GestureDetector( // Wrap with GestureDetector
      onTap: onTap, // Use the passed onTap callback
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 1),)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0)),
                child: Image.network(
                  imageUrl, fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) =>
                  (loadingProgress == null)
                      ? child
                      : Container(color: Colors.grey.shade200,
                      child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2.0))),
                  errorBuilder: (context, error, stackTrace) =>
                      Container(
                          color: Colors.grey.shade200,
                          child: Center(child: Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.grey.shade400))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(text, style: const TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 13),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildGridItemShimmer() { /* ... Shimmer build logic ... */
    return Container(
      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8.0)),
    );
  }
}

