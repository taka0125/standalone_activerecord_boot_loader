gem/release:
	@read -p "Enter OTP code: " otp_code; \
	gh workflow run release.yml -f rubygems-otp-code="$$otp_code"
