namespace clouds.itelo;

using from '../db/model';
using clouds.products.CatalogService from '@sap/cloud-samples-catalog';

extend service CatalogService with {

	entity Reviews @(
		title: '{i18n>review}',
		Capabilities: {
			InsertRestrictions: {Insertable: false},
			UpdateRestrictions: {Updatable: false},
			DeleteRestrictions: {Deletable: false}
		}
	) as projection on itelo.Reviews;

	entity Reviewers @(
		title: '{i18n>reviewer_XTIT}',
		Communication.Contact: {
			fn: name,
			tel: [
				{type: #fax, uri: faxNumber},
				{type: #cell, uri: mobilePhoneNumber},
				{type: [#preferred, #work], uri: phoneNumber}
			],
			email: [
				{type: [#work, #preferred], address: emailAddress}
			]
		}
	) as projection on itelo.Reviewers excluding { address };
}
