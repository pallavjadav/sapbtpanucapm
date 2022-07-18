namespace CAPM1.db;

using {
    cuid,
    temporal,
    Currency
} from '@sap/cds/common';

using {CAPM1.common} from './common';

type Guid : String(32);

annotate master.businesspartner with {
    NODE_KEY      @title : '{i18n>bp_key}';
    BP_ROLE       @title : '{i18n>bp_role}';
    COMPANY_NAME  @title : '{i18n>company_name}';
    BP_ID         @title : '{i18n>bp_id}';
    EMAIL_ADDRESS @title : '{i18n>emailaddr}';


};


context master {
    entity businesspartner {
        key NODE_KEY      : Guid;
            BP_ROLE       : String(2);
            EMAIL_ADDRESS : String(64);
            PHONE_NUMBER  : String(14);
            FAX_NUMBER    : String(14) @title : 'Fax Number';
            WEB_ADDRESS   : String(64) @title : 'Website';
            ADDRESS_GUID  : Association to address;
            BP_ID         : String(16);
            COMPANY_NAME  : String(250);
    }


    entity address {
        key NODE_KEY        : Guid;
            CITY            : String(64);
            POSTAL_CODE     : String(14);
            STREET          : String(64);
            BUILDING        : String(64);
            COUNTRY         : String(2);
            ADDRESS_TYPE    : String(10);
            VAL_START_DATE  : Date;
            VAL_END_DATE    : Date;
            LATITUDE        : Decimal;
            LONGITUDE       : Decimal;
            businesspartner : Association to one businesspartner
                                  on businesspartner.ADDRESS_GUID = $self;
    }

    entity employees : cuid {
        nameFirst     : String(40);
        nameMiddle    : String(40);
        nameLast      : String(40);
        nameInitials  : String(40);
        sex           : common.Gender;
        language      : String(1);
        phoneNumber   : String(15);
        email         : String(255);
        loginName     : String(12);
        Currency      : Currency;
        salaryAmount  : common.AmounT;
        accountNumber : String(16);
        bankId        : String(20);
        bankName      : String(64);
    }

    entity product {
        key NODE_KEY       : Guid;
            PRODUCT_ID     : String(28);
            TYPE_CODE      : String(2);
            CATEGORY       : String(32);
            DESCRIPTION    : localized String(255);
            SUPPLIER_GUID  : Association to master.businesspartner;
            TAX_TARIF_CODE : Integer;
            MEASURE_UNIT   : String(2);
            WEIGHT_MEASURE : Decimal(5, 2);
            WEIGHT_UNIT    : String(2);
            CURRENCY_CODE  : String(4);
            PRICE          : Decimal(15, 2);
            WIDTH          : Decimal(5, 2);
            DEPTH          : Decimal(5, 2);
            HEIGHT         : Decimal(5, 2);
            DIM_UNIT       : String(2);

    }

// entity prodtext {
//     key NODE_KEY: Guid;
//     PARENT_KEY: Guid;
//     LANGUAGE:String(2);
//     TEXT: String(256);
// }

}


context transaction {

    entity purchaseorder : common.Amount, cuid {
            PO_ID            : String(24);
            PARTNER_GUID     : Association to master.businesspartner;
            LIFECYCLE_STATUS : String(1);
            OVERALL_STATUS   : String(1);
            Items            : Association to many poitems
                                   on Items.PARENT_KEY = $self;
            NOTE             : String(256);
    }

    entity poitems : common.Amount , cuid{
            PARENT_KEY   : Association to purchaseorder;
            PO_ITEM_POS  : Integer;
            PRODUCT_GUID : Association to master.product;

    }

}
