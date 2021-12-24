// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./proxy/Proxy.sol";

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/StorageSlot.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/ClonesUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract MyNFT1 is ERC721Upgradeable {
    uint256 public constant version = 1;

    constructor() initializer {}

    function initialize(string calldata name, string calldata symbol) public initializer {
        __ERC721_init(name, symbol);
    }
}

contract MyNFT2 is ERC721Upgradeable {
    uint256 public constant version = 2;

    constructor() initializer {}

    function initialize(string calldata name, string calldata symbol) public initializer {
        __ERC721_init(name, symbol);
    }
}

contract MyNFT3 is ERC721Upgradeable {
    uint256 public constant version = 3;

    constructor() initializer {}

    function initialize(string calldata name, string calldata symbol) public initializer {
        __ERC721_init(name, symbol);
    }
}

contract TWFactory is Ownable {
    /// @dev type + version -> implementation contract address
    mapping(bytes32 => address) public implementation;

    /// @dev module type -> latest version
    mapping(string => uint256) public version;

    // TODO easily deploy our stuffs through our proxy
    constructor() {}

    event Deployed(address addy);

    function clone(address _impl, bytes memory _data) external {
        // TODO get impl from mapping
        emit Deployed(address(new TWProxy(_impl, _data)));
    }
}

contract TWProxy is Proxy {
    /**
     * @dev Storage slot with the address of the current implementation.
     * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
     * validated in the constructor.
     */
    bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    constructor(address _logic, bytes memory _data) payable {
        assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
        StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = _logic;
        if (_data.length > 0) {
            Address.functionDelegateCall(_logic, _data);
        }
    }

    /**
     * @dev Returns the current implementation address.
     */
    function _implementation() internal view override returns (address impl) {
        return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
    }
}
