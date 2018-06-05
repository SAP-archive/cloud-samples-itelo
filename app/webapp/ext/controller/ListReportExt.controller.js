sap.ui.define([
	"sap/ui/model/Filter",
	"sap/m/Token",
	"sap/m/RatingIndicator",
	"sap/m/ComboBox",
	"sap/m/MultiInput",
	"sap/ui/comp/smartfilterbar/SmartFilterBar"
], function(Filter, Token, RatingIndicator, ComboBox, MultiInput, SmartFilterBar) {
	"use strict";

	return sap.ui.controller("itelo-catalog.ext.controller.ListReportExt", {

		onInitSmartFilterBarExtension: function(oEvent) {
			// the custom field in the filter bar might have to be bound to a custom data model
			// if a value change in the field shall trigger a follow up action, this method is the place to define and bind an event handler to the field		
		},

		onBeforeRebindTableExtension: function(oEvent) {
			// usually the value of the custom field should have an effect on the selected data in the table. 
			// So this is the place to add a binding parameter depending on the value in the custom field.
			var oBindingParams = oEvent.getParameter("bindingParams");
			var oFilter, aFilter = [];
			oBindingParams.parameters = oBindingParams.parameters || {};
			var oSmartTable = oEvent.getSource();
			var oSmartFilterBar = this.byId(oSmartTable.getSmartFilterId());

			if (oSmartFilterBar instanceof SmartFilterBar) {
				//Custom Supplier filter
				var oCustomControl = oSmartFilterBar.getControlByKey("supplier_ID");
				if (oCustomControl instanceof MultiInput) {
					aFilter = this._getTokens(oCustomControl, "supplier_ID");
					if (aFilter.length > 0) {
						oBindingParams.filters.push.apply(oBindingParams.filters, aFilter);
					}
				}
				//Custom average rating filter
				oCustomControl = oSmartFilterBar.getControlByKey("averageRating");
				if (oCustomControl instanceof RatingIndicator) {
					oFilter = this._getRatingFilter(oCustomControl);
					if (oFilter) {
						oBindingParams.filters.push(oFilter);
					}
				}
			}
		},

		onCustomSupplierDialogOpen: function() {
			if (!this._oSupplierDialog) {
				this._oSupplierDialog = sap.ui.xmlfragment("itelo-catalog.ext.fragment.CustomSupplierFilterSelectDialog", this);
			}
			this.getView().addDependent(this._oSupplierDialog);
			this._oSupplierDialog.open();
		},

		onHandleCustomSupplierDialogSearch: function(oEvent) {
			var sValue = oEvent.getParameter("value");
			var oFilter = new Filter("name", sap.ui.model.FilterOperator.Contains, sValue);
			oEvent.getSource().getBinding("items").filter([oFilter]);
		},

		onHandleCustomSupplierTableSelectDialogClose: function(oEvent) {
			var aSelectedContext = oEvent.getParameter("selectedContexts");
			if (aSelectedContext && aSelectedContext.length >= 0) {
				var aTokens = [];
				for (var i = 0; i < aSelectedContext.length; i++) {
					var oToken = new Token({
						key: aSelectedContext[i].getObject().ID,
						text: aSelectedContext[i].getObject().name
					});
					aTokens.push(oToken);
				}
				var oMultiInput = this.getView().byId("Supplier-multiinput");
				oMultiInput.setTokens(aTokens);
				oMultiInput.fireChange();
			}
			oEvent.getSource().getBinding("items").filter([]);
			this.getView().updateBindings();
		},

		getCustomAppStateDataExtension: function(oCustomData) {
			//the content of the custom field shall be stored in the app state, so that it can be restored later again e.g. after a back navigation. 
			//The developer has to ensure, that the content of the field is stored in the object that is returned by this method.
			//Example:
			if (oCustomData) {
				var aKeyValues = [],
					oSmartFilterBar = this.byId("listReportFilter");
				if (oSmartFilterBar instanceof SmartFilterBar) {
					var oCustomControl = oSmartFilterBar.getControlByKey("averageRating");
					if (oCustomControl instanceof RatingIndicator) {
						oCustomData.AverageRatingValue = oCustomControl.getValue();
					}
					oCustomControl = oSmartFilterBar.getControlByKey("category_ID");
					if (oCustomControl instanceof MultiInput) {
						aKeyValues = this._getKeyValuePairs(oCustomControl);
						if (aKeyValues.length > 0) {
							oCustomData.ProductCategory = aKeyValues;
						}
					}
					oCustomControl = oSmartFilterBar.getControlByKey("supplier_ID");
					if (oCustomControl instanceof MultiInput) {
						aKeyValues = this._getKeyValuePairs(oCustomControl);
						if (aKeyValues.length > 0) {
							oCustomData.Supplier = aKeyValues;
						}

					}
				}
			}
		},

		restoreCustomAppStateDataExtension: function(oCustomData) {
			//in order to to restore the content of the custom field in the filter bar e.g. after a back navigation, 
			//an object with the content is handed over to this method and the developer has to ensure, that the content of the custom field is set accordingly
			//also, empty properties have to be set
			//Example:
			var oSmartFilterBar = this.byId("listReportFilter"),
				aTokens;

			if (oSmartFilterBar instanceof SmartFilterBar) {
				if (oCustomData.AverageRatingValue !== undefined) {
					var oCustomControl = oSmartFilterBar.getControlByKey("averageRating");
					if (oCustomControl instanceof RatingIndicator) {
						oCustomControl.setValue(oCustomData.AverageRatingValue);
					}
				}
				if (oCustomData.ProductCategory !== undefined) {
					oCustomControl = oSmartFilterBar.getControlByKey("category_ID");
					if (oCustomControl instanceof MultiInput) {
						aTokens = this._createTokens(oCustomData.ProductCategory);
						if (aTokens.length > 0) {
							oCustomControl.setTokens(aTokens);
						}
					}
				}
				if (oCustomData.Supplier !== undefined) {
					oCustomControl = oSmartFilterBar.getControlByKey("supplier_ID");
					if (oCustomControl instanceof MultiInput) {
						aTokens = this._createTokens(oCustomData.Supplier);
						if (aTokens.length > 0) {
							oCustomControl.setTokens(aTokens);
						}
					}
				}
			}
		},

		_getRatingFilter: function(oRatingSelect) {
			var sRating = oRatingSelect.getValue(),
				oFilter;
			if (sRating > 0) {
				//Apply lower and upper range for Average Rating filter
				var sRatingLower = sRating - 0.5;
				var sRatingUpper = sRating + 0.5;
				oFilter = new Filter("averageRating", sap.ui.model.FilterOperator.BT,
					sRatingLower, sRatingUpper);
			}
			return oFilter;
		},

		_getTokens: function(oControl, sName) {
			var aToken, aFilters = [];
			aToken = oControl.getTokens();
			if (aToken) {
				for (var i = 0; i < aToken.length; i++) {
					aFilters.push(new Filter(sName, "EQ", aToken[i].getProperty("key")));
				}
			}
			return aFilters;
		},

		_getKeyValuePairs: function(oCustomControl) {
			var aKeyValue = [],
				oToken = oCustomControl.getTokens();
			if (oToken) {
				for (var i = 0; i < oToken.length; i++) {
					aKeyValue.push([oToken[i].getProperty("key"), oToken[i].getProperty("text")]);
				}
			}
			return aKeyValue;
		},

		_createTokens: function(oCustomField) {
			var aTokens = [];
			for (var i = 0; i < oCustomField.length; i++) {
				aTokens.push(new Token({
					key: oCustomField[i][0],
					text: oCustomField[i][1]
				}));
			}
			return aTokens;
		}

	});
});