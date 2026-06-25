// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

/**
 * @title PriceConverter
 * @notice Library for converting ETH amounts to USD using Chainlink price feeds
 * @dev Uses Chainlink Aggregator V3 interface for price data
 */
library PriceConverter {
    /**
     * @notice Get the latest ETH price in USD
     * @return The current ETH/USD price with 18 decimal places
     */
    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        // ETH/USD rate in 18 digit
        // forge-lint: disable-next-line(unsafe-typecast)
        return uint256(answer * 10000000000);
    }

    /**
     * @notice Convert ETH amount to USD equivalent
     * @param ethAmount The amount of ETH to convert
     * @return ethAmountInUsd The ETH amount converted to USD
     */
    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        // the actual ETH/USD conversion rate, after adjusting the extra 0s.
        return ethAmountInUsd;
    }
}