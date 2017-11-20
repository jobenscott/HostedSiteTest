class HostedSitePaymentService < ApplicationRecord
	PAYMENT_SERVICE_REFERENCE_DATA = {
		:stripe => {
			:display_name => 'stripe',
			:hosted_site_value => 0
		},
		:paypal => {
			:display_name => 'paypal',
			:hosted_site_value => 1
		}
	}
end