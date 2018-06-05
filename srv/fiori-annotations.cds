using clouds.products.CatalogService as cats from './itelo-service';

annotate cats.Products with @( // header-level annotations
// ---------------------------------------------------------------------------
// List Report
// ---------------------------------------------------------------------------
	// Product List
	UI: {
		LineItem: [ 
			{$Type: 'UI.DataField', Value: image, "@UI.Importance": #High},
			{$Type: 'UI.DataField', Value: ID, "@UI.Importance":#High}, 
			{$Type: 'UI.DataField', Value: category.name, "@UI.Importance": #Medium}, 
			{$Type: 'UI.DataFieldForAnnotation', Label: '{i18n>supplier}', Target: 'supplier/@Communication.Contact', "@UI.Importance": #Medium},
			{$Type: 'UI.DataField', Value: stock.availability.code, Criticality: stock.availability.code, "@UI.Importance": #High},
			{$Type: 'UI.DataFieldForAnnotation', Target: '@UI.DataPoint#AverageRatingValue', "@UI.Importance": #High},
			{$Type: 'UI.DataField', Value: price, "@UI.Importance": #High}
		],
		DataPoint#AverageRatingValue: {
			Value: averageRating,
			TargetValue: 5,
			Visualization: #Rating
		}
	},

// ---------------------------------------------------------------------------
// Object Page
// ---------------------------------------------------------------------------
	// Page Facets
	UI.Facets: [
		{
			$Type: 'UI.CollectionFacet',
			ID: 'ProductDetails',
			Label: '{i18n>productDetails}',
			Facets: [
				{$Type: 'UI.ReferenceFacet', Label: '{i18n>technicalData}', Target: '@UI.FieldGroup#TechnicalData'},
				{$Type: 'UI.ReferenceFacet', Label: '{i18n>administrativeData}', Target: '@UI.FieldGroup#AdministrativeData'},
			]
		},
		{$Type: 'UI.ReferenceFacet', Label: '{i18n>review_Plural}', Target: 'reviews/@UI.LineItem'}
	]
);

annotate cats.Reviews with @( // header-level annotations
// ---------------------------------------------------------------------------
// Object Page
// ---------------------------------------------------------------------------
	// Review List on Product Object Page
	UI: {
		LineItem: 
		[
			{$Type: 'UI.DataFieldForAnnotation', Target: '@UI.DataPoint#ReviewRatingValue'},
			{$Type: 'UI.DataField', Label: '{i18n>reviewer_XTIT}', Value: reviewer.name},
			{$Type: 'UI.DataField', Label: '{i18n>reviewDate_XTIT}', Value: created_at, "@UI.Importance": #Medium},
			{$Type: 'UI.DataField', Value: message},
			{$Type: 'UI.DataFieldForAnnotation', Target: '@UI.DataPoint#HelpfulCount'}
		],
		DataPoint#ReviewRatingValue: {
			Value: rating,
			Title: '{i18n>rating}',
			TargetValue: 5,
			Visualization: #Rating
		},
		DataPoint#HelpfulCount: {
			Value: helpfulCount,
			Title: '{i18n>feedback}',
			TargetValue: helpfulTotal,
			Visualization: #Progress
		},
		PresentationVariant: {
			SortOrder: [ {$Type: 'Common.SortOrderType', Property: created_at, Descending: true} ]
		}
	},

	// Page Header on Review Object Page
	UI: {
		HeaderInfo: {
			TypeName: '{i18n>review}',
			TypeNamePlural: '{i18n>review_Plural}',
			Title: { Value: title },
			Description: { Value: reviewer.name }
		},
		HeaderFacets: [
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>review}', Target: '@UI.FieldGroup#Metadata'},
			{$Type: 'UI.ReferenceFacet', Target: '@UI.DataPoint#ReviewRatingValue'},
			{$Type: 'UI.ReferenceFacet', Target: '@UI.DataPoint#HelpfulCount'}
		],
		FieldGroup#Metadata: {
			Label: '{i18n>review}',
			Data: [
				{$Type: 'UI.DataFieldForAnnotation', Label: '{i18n>reviewer_XFLD}', Target: 'reviewer/@Communication.Contact'},
				{$Type: 'UI.DataField', Label: '{i18n>reviewDate_XFLD}', Value: created_at, "@UI.Importance": #Medium}
			]
		}
	},

	// Page Facets on Review Object Page
	UI: {
		Facets: [
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>review}', Target: '@UI.FieldGroup#ReviewText', "@UI.Importance": #High}
		],
		FieldGroup#ReviewText: {
			Label: '{i18n>review}',
			Data: [
				{$Type: 'UI.DataField', Value: title},
				{$Type: 'UI.DataField', Value: message}
			]
		}
	}
);

annotate cats.Categories with @( // header-level annotations
// ---------------------------------------------------------------------------
// List Report
// ---------------------------------------------------------------------------
	// Filter Bar
	UI.SelectionFields: [ created_byUser ],

	// Category List
	UI: {
		LineItem: [ 
			{$Type: 'UI.DataField', Value: name, "@UI.Importance": #High},
			{$Type: 'UI.DataField', Value: description, "@UI.Importance": #High},
			{$Type: 'UI.DataField', Value: modified_byUser, "@UI.Importance": #High},
			{$Type: 'UI.DataField', Value: modified_at, "@UI.Importance": #High}
		],
		PresentationVariant: {
			SortOrder: [ {$Type: 'Common.SortOrderType', Property: name, Descending: false} ]
		}
	},
// ---------------------------------------------------------------------------
// Object Page
// ---------------------------------------------------------------------------
	// Page Header
	UI: {
		HeaderInfo: {
			TypeName: 'Category',
			TypeNamePlural: 'Categories',
			Title: {Value: name},
		},
		HeaderFacets: [
			{$Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#Description', "@UI.Importance": #Medium},
		],
		FieldGroup#Description: {
			Data: [ {$Type: 'UI.DataField', Value: description} ]
		}
	},
	// Page Facet
	UI: {
		Facets:[
			{$Type: 'UI.ReferenceFacet', Label: '{i18n>administrativeData}', Target: '@UI.FieldGroup#AdministrativeData'},
		],
		FieldGroup#AdministrativeData: {
			Label: '{i18n>administrativeData}',
			Data: [
				{$Type: 'UI.DataField', Value: created_byUser, "@UI.Importance": #Medium},
				{$Type: 'UI.DataField', Value: created_at, "@UI.Importance": #Medium},
				{$Type: 'UI.DataField', Value: modified_byUser, "@UI.Importance": #Medium},
				{$Type: 'UI.DataField', Value: modified_at, "@UI.Importance": #Medium}
			]
		}
	}
);