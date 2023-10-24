import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management/refactored/core/controllers/category_configure_controller.dart';
import 'package:money_management/refactored/core/models/category.dart';
import 'package:money_management/refactored/core/models/transaction.dart';
import 'package:money_management/refactored/widgets/button/m_button.dart';
import 'package:money_management/refactored/widgets/container/m_container.dart';
import 'package:money_management/refactored/widgets/input/m_input_text_field.dart';
import 'package:money_management/refactored/widgets/space/m_space.dart';
import 'package:money_management/refactored/widgets/text/m_text.dart';

class CategoryConfigureScreen extends StatefulWidget {
  const CategoryConfigureScreen({
    super.key,
    required this.transactionType,
  });

  final TransactionType transactionType;

  @override
  State<CategoryConfigureScreen> createState() =>
      _CategoryConfigureScreenState();
}

class _CategoryConfigureScreenState extends State<CategoryConfigureScreen> {
  final controller = Get.put(CategoryConfigureController());

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      controller.initialize(widget.transactionType);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: MText(
          text: '${widget.transactionType.name.capitalizeFirst} Category',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () => _showAddCategory(null),
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: Obx(() {
        return ListView(
          children: List.generate(controller.categories.length, (index) {
            final category = controller.categories[index];
            return _buildCategoryItem(category, index);
          }),
        );
      }),
    );
  }

  Widget _buildCategoryItem(Category category, int index) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: MText(
          text: '${index + 1}.',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        title: MText(
          text: category.name?.capitalizeFirst ?? '',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        trailing: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {
              _showMenu(context, category, index);
            },
          );
        }),
      ),
    );
  }

  void _showMenu(
    BuildContext context,
    Category category,
    int index,
  ) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset position =
        button.localToGlobal(Offset.zero, ancestor: overlay);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + button.size.height,
        position.dx + button.size.width,
        position.dy + button.size.height,
      ),
      items: <PopupMenuEntry>[
        PopupMenuItem(
          onTap: () {
            _showAddCategory(index);
          },
          child: const ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit'),
          ),
        ),
        PopupMenuItem(
          onTap: () => controller.deleteCategory(
            index,
            category.id ?? 0,
          ),
          child: const ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete'),
          ),
        ),
      ],
    );
  }

  Future<void> _showAddCategory(
    int? index,
  ) async {
    final text = TextEditingController(
      text: index == null ? null : controller.categories[index].name,
    );
    final focus = FocusNode();
    focus.requestFocus();
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          children: [
            MInputTextField(
              controller: text,
              label: 'Category',
              focusNode: focus,
            ),
            MSpace.vertical(30),
            MButton(
              onPress: () async {
                if (text.text.trim().isEmpty) {
                  return;
                }
                if (index == null) {
                  await controller.addCategory(
                    text.text.trim(),
                    widget.transactionType,
                  );
                } else {
                  await controller.editCategory(
                    text.text.trim(),
                    index,
                  );
                }
                Get.back();
              },
              text: 'Add',
            ),
          ],
        ),
      ),
    );
    text.dispose();
    focus.dispose();
  }
}
