//SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Exchange is ERC20 {
    constructor(address _CryptoDevtoken) ERC20("CryptoDev LP Token", "CDLP") {
        require(_CryptoDevtoken != address(0), "Token address is a null address");
        cryptoDevTokenAddress = _CryptoDevtoken;
    }
}

function getReserve() public view returns (uint) {
    return ERC20(cryptoDevTokenAddress).balanceOf(address(this));
}

function addLiquidity(uint _amount) public payable returns (uint) {
    uint liquidity;
    uint ethBalance = address(this).balance;
    uint cryptoDevTokenReserve = getReserve();
    ERC20 cryptoDevTOken = ERC20(cryptoDevTokenAddress);

    if(cryptoDevTokenReserve == 0) {
        cryptoDevToken.transferFrom(msg.sender, address(this), _amount);
        liquidity = ethBalance;
        _mint(msg.sender, liquidity);
    } else {
        uint ethReserve = ethBalance - msg.value;
        uint cryptoDevTokenAmount = (msg.value * cryptoDevTokenReserve)/(ethReserve);
        require(_amount >= cryptoDevTokenAmount, "Amount of tokens sent is less than minimum token required");
        cryptoDevTOken.transferFrom(msg.sender, address(this), cryptoDevTokenAmount);
        liquidity = (totalSupply() * msg.value)/ethReserve;
        _mint(msg.sender, liquidity);
    }
    return liquidity;
}

function removeLiquidity(uint _amount) public returns (uint , uint) {
    require(_amount > 0, "_amount should be greater than 0");
    uint ethReserve = address(this).balance;
    uint _totalSupply = totalSupply();

    uint ethAmount = (ethReserve * _amount)/ _totalSupply;
    uint cryptoDevTokenAmount = (getReserve() * _amount)/ _totalSupply;
    _burn(msg.sender).transfer(ethAmount);
    payable(msg.sender).transfer(ethAmount);
    ERC20(cryptoDevTokenAddress).transfer(msg.sender, cryptoDevTokenAmount);
    return (ethAmount, cryptoDevTokenAmount);
}

function getAmountOfTokens(
    uint256 inputAmount,
    uint256 inputReserve,
    uint256 outputReserve
) public pure returns (uint256) {
    require(inputReserve > 0 && outputReserve > 0, "invalid reserves");
    uint256 inputAmountWithFee = inputAmount * 99;
    uint256 numerator = inputAmountWithFee * outputReserve;
    uint256 denominator = (inputReserve * 100) + inputAmountWithFee;
    return numerator / denominator;
}

function ethToCryptoDevToken(uint _minTokens) public payable {
    
}