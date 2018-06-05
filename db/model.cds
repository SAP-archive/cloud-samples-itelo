namespace clouds.itelo;

using clouds.products.Products from '@sap/cloud-samples-catalog';
using clouds.foundation as fnd from '@sap/cloud-samples-foundation';

extend Products with {
	reviews: Association to many Reviews on reviews.product = $self @title: '{i18n>review}';
	averageRating: Decimal(4, 2) @(
		title: '{i18n>averageRating}',
		Common.FieldControl: #ReadOnly
	);
	numberOfReviews: Integer @(
		title: '{i18n>numberOfReviews}',
		Common.FieldControl: #ReadOnly
	);
}

entity Reviews: fnd.BusinessObject {
	product: Association to Products @title: '{i18n>product}';
	reviewer: Association to Reviewers @title: '{i18n>reviewer_XTIT}';
	title: String(60) @title: '{i18n>reviewTitle}';
	message: String(1024) @title: '{i18n>reviewText}';
	rating: Decimal(4, 2) @title: '{i18n>rating}';
	helpfulCount: Integer @title: '{i18n>ratedHelpful}';
	helpfulTotal: Integer @title: '{i18n>ratedTotal}';
}

annotate Reviews with {
	ID @title: '{i18n>review}';
}

entity Reviewers: fnd.Person, fnd.BusinessObject {
}

annotate Reviewers with {
	ID @title: '{i18n>reviewer_XTIT}';
}
