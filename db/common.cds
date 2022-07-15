namespace CAPM1.common;

using {sap, Currency, temporal, managed} from '@sap/cds/common';

type AmounT: Decimal(15,2)@(
    Semantic.amount.currencyCode: 'CURRENCY_CODE',
    sap.unit: 'CURRENCY_CODE'
);



define aspect Amount  {
    CURRENCY_CODE: String(4);
    GROSS_AMOUNT: AmounT;
    NET_AMOUNT: AmounT;
    TAX_AMOUNT: AmounT;
};





type Gender : String(1) enum{
     male = 'M';
     female = 'F';
     nonBinary= 'N';
     noDisclosure = 'D';
     selfDescribe = 'S';

};

//type phoneNumber : String(30)@assert.format : '((?:\+|00)[17](?: |\-)?|(?:\+|00)[1-9]\d{0,2}(?: |\-)?|(?:\+|00)1\-\d{3}(?: |\-)?)?(0\d|\([0-9]{3}\)|[1-9]{0,3})(?:((?: |\-)[0-9]{2}){4}|((?:[0-9]{2}){4})|((?: |\-)[0-9]{3}(?: |\-)[0-9]{4})|([0-9]{7}))';
//type Email:String(255)@assert.format : '^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$';

