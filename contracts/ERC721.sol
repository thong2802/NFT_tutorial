pragma solidity ^0.8.2;


contract ERC721 {
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    mapping(address => uint256) internal _banlance;
    mapping(uint256 => address) internal _owner;
    mapping(address=> mapping(address => bool)) private _operatorApprivals;
    mapping(uint256 => address) private _tokenApprovals;

    // return number of NFTs of user
    function balanceOf(address owner) external view returns (uint256) {
        require(owner != address(0), "address is zero");
        return _banlance[owner];
    }
    // find owner of NFT
    function ownerOf(uint256 _tokenId) public view returns (address) {
        address owner = _owner[_tokenId];
        require(owner != address(0), "tokenId does not exists");
        return  owner;
    }
    // if tranfer a NFT to smartcontract, neeed using safeTransferFrom, because it will check smartcontract have
    // implement function receiver NFT.
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public payable {
        transferFrom(from, to, tokenId);
        require(_checkonERC721Received(), "Receiver not available implement");
    }
    // simple versiob to check for nft receivability of a smartcontract.
    function _checkonERC721Received() private pure returns(bool) {
        return true;
    }
    // if tranfer a NFT to smartcontract, neeed using safeTransferFrom, because it will check smartcontract have
    // implement function receiver NFT.
    function safeTransferFrom(address from, address to, uint256 tokenId) external payable {
        safeTransferFrom(from, to, tokenId, "");   
    }
    // Transfer ownership of a single NFT
    function transferFrom(address _from, address _to, uint256 _tokenId) public payable {
        address owner = _owner[_tokenId];
        require(
            msg.sender == owner || 
            getApproved(_tokenId) == msg.sender ||
            isApprovedForAll(owner, msg.sender), 
            "Msg.sender is not a owner or is not approve for transfer"
        );
        require(owner == _from, "from address is not the owner"); 
        require(_to == address(0), "to address is the zero address");
        require(_owner[_tokenId] != address(0), "Token ID doens not exsist");
        approve(address(0), _tokenId);
        _banlance[_from] -= 1;
        _banlance[_to] += 1;
        _owner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }
    // Updates an approved address for an NFTs.
    function approve(address _approved, uint256 _tokenId) public payable {
        address owner = ownerOf(_tokenId);
        require(msg.sender == owner || isApprovedForAll(owner, msg.sender), "msg.sender is not the owner or not approve the operator");
        _tokenApprovals[_tokenId] = _approved;
        emit Approval(owner, _approved, _tokenId);
    }
    // enable or disable the operator
    function setApprovalForAll(address _operator, bool _approved) external {
        _operatorApprivals[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender,_operator, _approved);
    }

    // get the approved address for an NFT.
    function getApproved(uint256 _tokenId) public view returns (address) {
        require(_owner[_tokenId] != address(0), "Token ID doens not exsist");
        return _tokenApprovals[_tokenId];
    }
    // check if the operator is an onether operator address;
    function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
        return _operatorApprivals[_owner][_operator];
    }
    // EIP165 proponal : query is if contract implements onether interface.
    function supportsInterface(bytes4 interfaceId) public pure virtual returns (bool) {
        return interfaceId == 0x80ac58cd;
    }

}