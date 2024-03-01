#!/bin/bash

# Function to retrieve API options based on module
get_api_options() {
	local module="$1"
	jq -r --arg module "$module" '.item[0].item[] | select(.name == $module) | .item[].name' postman.json
}

# Function to retrieve response options based on module and API
get_response_options() {
	local module="$1"
	local api="$2"
	jq -r --arg module "$module" --arg api "$api" '.item[0].item[] | select(.name == $module) | .item[] | select(.name == $api) | .response[].name' postman.json
}

# Function to retrieve response body based on module, api, and response option
get_response_body() {
	local module="$1"
	local api="$2"
	local response_option="$3"
	jq -r --arg module "$module" --arg api "$api" --arg response_option "$response_option" \
		'.item[0].item[] | select(.name == $module) | .item[] | select(.name == $api) | .response[] | select(.name == $response_option)' \
		postman.json
}

# Read the module names from the Postman collection
MODULEOPTIONS=$(jq -r '.item[0].item[].name' postman.json)
IFS=$'\n'

# Display the module selection menu and prompt the user for selection
select module in $MODULEOPTIONS; do
	if [ -n "$module" ]; then
		# Extract API options based on the selected module
		APIOPTIONS=$(get_api_options "$module")

		# Display the API selection menu and prompt the user for selection
		select api in $APIOPTIONS "Back"; do
			if [ -n "$api" ]; then
				# Extract response options based on the selected API
				RESPONSEOPTIONS=$(get_response_options "$module" "$api")

				# Display the response selection menu and prompt the user for selection
				select response_option in $RESPONSEOPTIONS "Back"; do
					if [ -n "$response_option" ]; then
						# Get the response body based on the selected module, API, and response option
						RESPONSE_BODY=$(get_response_body "$module" "$api" "$response_option")
						formatted_json=$(echo "$RESPONSE_BODY" | jq -c 'del(.header)' -r)
						echo "$formatted_json" >/tmp/formatted_json.json
						nvim /tmp/formatted_json.json

						# nvim <(echo "$BODY" | jq 'del(.header)')
						break
					elif [ "$REPLY" = "Back" ]; then
						break
					else
						echo "Invalid option, please try again."
					fi
				done
				break
			elif [ "$REPLY" = "Back" ]; then
				break
			else
				echo "Invalid option, please try again."
			fi
		done
	else
		echo "Invalid option, please try again."
	fi
done
