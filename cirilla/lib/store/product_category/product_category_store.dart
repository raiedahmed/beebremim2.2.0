import 'package:cirilla/constants/app.dart' as app_configs;
import 'package:cirilla/models/product_category/product_category.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/error/error_store.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:mobx/mobx.dart';

part 'product_category_store.g.dart';

class ProductCategoryStore = _ProductCategoryStore with _$ProductCategoryStore;

abstract class _ProductCategoryStore with Store {
  // Request helper instance
  RequestHelper? _requestHelper;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:-------------------------------------------------------------------------------------------------------
  _ProductCategoryStore(RequestHelper requestHelper, {int? parent, int? perPage, bool? hideEmpty, String? language}) {
    _requestHelper = requestHelper;
    if (parent != null) _parent = parent;
    if (perPage != null) _perPage = perPage;
    if (hideEmpty != null) _hideEmpty = hideEmpty;
    if (language != null && language != '') _language = language;
    _reaction();
  }

  // store variables:---------------------------------------------------------------------------------------------------
  static ObservableFuture<List<ProductCategory>> emptyPostResponse = ObservableFuture.value([]);

  @observable
  ObservableFuture<List<ProductCategory>?> fetchCategoriesFuture = emptyPostResponse;

  @observable
  ObservableList<ProductCategory> _categories = ObservableList<ProductCategory>.of([]);

  @observable
  bool success = false;

  @observable
  bool _canLoadMore = true;

  @observable
  String _language = app_configs.defaultLanguage;

  @observable
  int _nextPage = 1;

  @observable
  int _perPage = 10;

  @observable
  int _parent = 0;

  /// Whether to hide resources not assigned to any products
  @observable
  bool _hideEmpty = false;

  @observable
  String _search = '';

  @observable
  Map _sort = {
    'key': 'latest',
    'query': {
      'order': 'desc',
      'orderby': 'date',
    }
  };

  // computed:----------------------------------------------------------------------------------------------------------
  @computed
  RequestHelper? get requestHelper => _requestHelper;

  @computed
  bool get loading => fetchCategoriesFuture.status == FutureStatus.pending;

  @computed
  ObservableList<ProductCategory> get categories => _categories;

  @computed
  bool get canLoadMore => _canLoadMore;

  @computed
  Map get sort => _sort;

  @computed
  int get parent => _parent;

  @computed
  int get perPage => _perPage;

  // actions:-----------------------------------------------------------------------------------------------------------
  @action
  Future<void> getCategories() async {
    final future = _requestHelper!.getProductCategories(queryParameters: {
      "page": _nextPage,
      "search": _search,
      "parent": _parent,
      "per_page": _perPage,
      "hide_empty": _hideEmpty,
      "lang": _language,
      // "orderby": _sort['query']['orderby'],
    });
    fetchCategoriesFuture = ObservableFuture(future);
    return future.then((categories) {
      _categories = ObservableList<ProductCategory>.of(categories!);
    }).catchError((error) {
      avoidPrint(error);
      // errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  Future<void> refresh() {
    _canLoadMore = true;
    _nextPage = 1;
    return getCategories();
  }

  @action
  void onChanged({
    Map? sort,
    String? search,
    int? parent,
    int? perPage,
    String? language,
  }) {
    if (sort != null) _sort = sort;
    if (search != null) _search = search;
    if (parent != null) _parent = parent;
    if (perPage != null) _perPage = perPage;
    if (language != null) _language = language;
  }

  // disposers:---------------------------------------------------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _reaction() {
    _disposers = [
      reaction((_) => _language, (dynamic key) => refresh()),
    ];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
