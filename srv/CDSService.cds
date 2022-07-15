using {CAPM1.db.CDSViews} from '../db/CDSViews';

using {
    CAPM1.db.master,
    CAPM1.db.transaction
} from '../db/datamodel';

service CDSService@(path:'/CDSService') {

    entity POWorklist as projection on CDSViews.POWorklist;

    entity ProductOrders as projection on CDSViews.ProductViewSub;
    entity ProductAggregation as projection on CDSViews.CProductValuesView;

}
