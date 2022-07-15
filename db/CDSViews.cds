namespace CAPM1.db;

using {
    CAPM1.db.master,
    CAPM1.db.transaction
} from './datamodel';

context CDSViews {

    define view![POWorklist] as
        select from transaction.purchaseorder {
            key PO_ID                             as![PurchaseOrderId],
                PARTNER_GUID.BP_ID                as![PartnerId],
                PARTNER_GUID.COMPANY_NAME         as![CompanyName],
                GROSS_AMOUNT                      as![POGrossAmount],
                CURRENCY_CODE                     as![POCurrencyCode],
                LIFECYCLE_STATUS                  as![POStatus],
            key Items.PO_ITEM_POS                 as![ItemPosition],
                Items.PRODUCT_GUID.PRODUCT_ID     as![ProductId],
                Items.PRODUCT_GUID.DESCRIPTION    as![ProductName],
                PARTNER_GUID.ADDRESS_GUID.CITY    as![City],
                PARTNER_GUID.ADDRESS_GUID.COUNTRY as![Country],
                Items.GROSS_AMOUNT                as![GrossAmount],
                Items.NET_AMOUNT                  as![NetAmount],
                Items.TAX_AMOUNT                  as![TaxAmount],
                Items.CURRENCY_CODE               as![CurrencyCode]

        };


    //View using select for Product Value Help
    define view ProductVH as
        select from master.product {


            @EndUserText.label : [{
                language : 'EN',
                text     : 'Product ID'
            }, {
                language : 'DE',
                text     : 'Prodeckt ID'
            }]
            PRODUCT_ID  as![ProductId],


            @EndUserText.label : [{
                language : 'EN',
                text     : 'Product Description'
            }, {
                language : 'DE',
                text     : 'Prodeckt Description'
            }]
            DESCRIPTION as![Description]


        };

    //View purchase order item

    define view![ItemView] as
        select from transaction.poitems {
            PARENT_KEY.PARTNER_GUID.NODE_KEY as![Partner],
            PRODUCT_GUID.NODE_KEY            as![ProductId],
            CURRENCY_CODE                    as![CurrencyCode],
            GROSS_AMOUNT                     as![GrossAmount],
            NET_AMOUNT                       as![NetAmount],
            TAX_AMOUNT                       as![TaxAmount],
            PARENT_KEY.OVERALL_STATUS        as![POStatus]


        };

    //total sales per product

    define view ProductViewSub as
        select from master.product as prod {
            PRODUCT_ID        as ![ProductId],
            texts.DESCRIPTION as ![Description],

            (
                select from transaction.poitems as a {
                    SUM(a.GROSS_AMOUNT) as SUM  
                }
                where
                    a.PRODUCT_GUID.NODE_KEY = prod.NODE_KEY

            )  as PO_SUM:Decimal(10, 2)
        };

    //View on view plus association

    define view ProductView as 
    select from master.product
    mixin{
        PO_ORDERS: Association[*] to ItemView on    
            PO_ORDERS.ProductId =$projection.ProductId 
    }
    into{
        NODE_KEY as![ProductId],
        DESCRIPTION,
        CATEGORY as![Category],
        PRICE as![Price],
        TYPE_CODE as![TypeCode],
        SUPPLIER_GUID.BP_ID as![BPId],
        SUPPLIER_GUID.COMPANY_NAME as![CompanyName],
        SUPPLIER_GUID.ADDRESS_GUID.CITY as![City],
        SUPPLIER_GUID.ADDRESS_GUID.COUNTRY as![Country],
       
       //Exposed association which mean when someone read this view
       //the data for order won't be read by default until unless someoen consume association 
        PO_ORDERS
    };

    define view CProductValuesView as 
        select from ProductView{
            ProductId,
            Country,
            PO_ORDERS.CurrencyCode as![CurrencyCode],
            sum(PO_ORDERS.GrossAmount) as![POGrossAmount]:Decimal(10, 2)
        }
        group by ProductId, Country, PO_ORDERS.CurrencyCode
}
