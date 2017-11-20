class HostedSiteFeature < ApplicationRecord
	FEATURE_REFERENCE_DATA = {
		:repair => {
			:display_name => 'repair',
			:hosted_site_value => 0
		},
		:buyback => {
			:display_name => 'buyack',
			:hosted_site_value => 1
		}
	}
end