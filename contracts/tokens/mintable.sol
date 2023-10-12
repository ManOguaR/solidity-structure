// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {Context} from "@openzeppelin/contracts/utils/Context.sol";

interface IMintable {
    function mint(address to, uint256 amount) external returns (bool);

    function assignMinterRole(address assignedMinter) external;
    function revokeMinterRole(address revokedMinter) external;
}

abstract contract ERC20Mintable is Context, ERC20, IMintable, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    event TokensMinted(address indexed by, address indexed to, uint256 amount);

    constructor(address defaultAdmin, address minter)
    {
        _grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
        _grantRole(MINTER_ROLE, minter);
    }

    function mint(address to, uint256 amount) public override onlyRole(MINTER_ROLE) returns (bool) {
        _mint(to, amount);
        emit TokensMinted(_msgSender(), to, amount);
        return  true;
    }

    function assignMinterRole(address assignedMinter) public override onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(MINTER_ROLE, assignedMinter);
    }
    
    function revokeMinterRole(address revokedMinter) public override onlyRole(DEFAULT_ADMIN_ROLE) {
        _revokeRole(MINTER_ROLE, revokedMinter);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IMintable).interfaceId || super.supportsInterface(interfaceId);
    }
}