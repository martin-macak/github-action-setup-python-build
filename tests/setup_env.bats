# shellcheck disable=SC2317

load helper

@test 'setup_env' {
	source ../src/setup_env.sh

	GITHUB_OUTPUT=$(mktemp)
	GITHUB_PATH=$(mktemp)

	function command() {
		echo '1.2.3'
	}

	export GITHUB_OUTPUT
	export GITHUB_PATH
	export -f command

	run setup_env
	assert_success
	assert_equal "$(cat <"$GITHUB_OUTPUT" | grep '^system-poetry-version' | cut -d '=' -f 2)" '1.2.3'

	unset command
}
