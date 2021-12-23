// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./proxy/Proxy.sol";
import "./proxy/ERC1967Proxy.sol";

contract ThirdwebFactory {
    // TODO easily deploy our stuffs through our proxy
}

contract ThirdwebProxy is Proxy, ERC1967Upgrade {
    constructor(address _logic, bytes memory _data) payable {
        assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
        _upgradeToAndCall(_logic, _data, false);
        _changeAdmin(msg.sender);
    }

    function _implementation() internal view virtual override returns (address impl) {
        return ERC1967Upgrade._getImplementation();
    }

    // TODO upgrade, make sure upgrade is good
}
