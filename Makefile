.PHONY: help
help:
	@grep "^[a-zA-Z][a-zA-Z0-9\-\/\_]*:" -o Makefile | grep -v "grep" | sed -e 's/^/make /' | sed -e 's/://'
gem/release:
	@read -p "Enter OTP code: " otp_code; \
	gh workflow run release.yml -f rubygems-otp-code="$$otp_code"
