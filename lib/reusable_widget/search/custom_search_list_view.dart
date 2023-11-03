import 'package:abha/export_packages.dart';

class CustomSearchListView extends StatefulWidget {
  final List<LocalSearch> itemList;
  final LocalSearch? selectedItem;
  final Function(LocalSearch item) onClick;
  final String title;
  final String hintSearch;

  const CustomSearchListView({
    required this.selectedItem,
    required this.onClick,
    required this.itemList,
    required this.title,
    required this.hintSearch,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomSearchListView> createState() => _CustomSearchListViewState();
}

class _CustomSearchListViewState extends State<CustomSearchListView> {
  List<LocalSearch> filterList = [];
  AppTextController textController = AppTextController();

  @override
  void initState() {
    filterList.addAll(widget.itemList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: WidgetUtility.spreadWidgets(
        [
          Text(
            widget.title,
            style: CustomTextStyle.bodyMedium(context)?.apply(),
          ),
          AppTextFormField.desktop(
            context: context,
            autofocus: true,
            prefix: const Icon(Icons.search),
            textEditingController: textController,
            hintText: widget.hintSearch,
            onChanged: (value) {
              List<LocalSearch> tempList = filterList
                  .where(
                    (element) => element.title
                        .trim()
                        .toLowerCase()
                        .contains(value.trim().toLowerCase()),
                  )
                  .toList();
              setState(() {
                if (value.isEmpty) {
                  filterList.clear();
                  filterList.addAll(widget.itemList);
                } else {
                  filterList.clear();
                  filterList.addAll(tempList);
                }
              });
            },
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                LocalSearch item = filterList[index];
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    context.navigateBack();

                    widget.onClick(item);
                  },
                  child: Container(
                    padding: EdgeInsets.all(Dimen.d_14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: InputFieldStyleMobile.inputFieldStyle,
                          ),
                        ),
                        if (widget.selectedItem == item)
                          const Icon(
                            Icons.check,
                            color: AppColors.colorAppBlue1,
                          )
                        else
                          const SizedBox.shrink()
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Container(
                  height: 1,
                  width: double.infinity,
                  color: AppColors.colorPurple4,
                );
              },
              itemCount: filterList.length,
            ),
          )
        ],
        interItemSpace: 10,
        flowHorizontal: false,
      ),
    );
  }
}
