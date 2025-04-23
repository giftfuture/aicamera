import 'package:aicamera/pages/autogenpic.dart';
import 'package:aicamera/pages/choosemodel.dart';
import 'package:aicamera/pages/chooseprint.dart';
import 'package:aicamera/pages/index.dart';
import 'package:aicamera/pages/lottery.dart';
import 'package:aicamera/pages/modelcategory.dart';
import 'package:aicamera/pages/takephoto.dart';
import 'package:aicamera/pages/unknown.dart';
import 'package:get/get.dart';

final routes = [
  GetPage(name: '/autogenpic', page: () => const AutoGenPicPage()),
  GetPage(name: '/choosemodel', page: () => const ChooseModelPage()),
  GetPage(name: '/chooseprint', page: () => const ChoosePrintPage()),
  GetPage(name: '/index', page: () => const IndexPage()),
  GetPage(name: '/lottery', page: () => const LotteryPage()),
  GetPage(name: '/modelcategory', page: () => const ModelCategoryPage()),
  GetPage(name: '/takephoto', page: () => const TakePhotoPage()),
  GetPage(name: '/unknown', page: () => const UnknownRoutePage()),

];
