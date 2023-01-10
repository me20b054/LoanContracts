// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "./SwapToken.sol";  

contract Token {

    address public Owner;  
    string public name = "Bank Rupee"; 
    string public symbol = "BR";
    uint256 public totalSupply = 1000; // 1000 Tokens
    uint256 public rate ;  
    SwapToken public swaptoken;   

    mapping(address => uint) public Time1;
    mapping(address => uint) public Time2; 
    mapping(address => uint256) public balanceOf;  // ledger of BR Tokens 
    mapping(address => uint256) public Loans;   

    constructor(uint _rate){ 
        rate = _rate;      
        Owner = msg.sender; 
        balanceOf[msg.sender] = totalSupply;   
        //swapeth = _swapeth; 
    }
    
    event takeloan(address indexed _from,address indexed _to,uint value) ;  
    event Transfer(address indexed _from,address indexed _to,uint256 _value); 
    event loanreturn(address indexed _form,address indexed _to,uint256 value); 
    

    function transfer(address _to,uint value) public{  
        require(balanceOf[msg.sender] >= value); 
        balanceOf[msg.sender] -= value;
        balanceOf[_to] += value; 
        emit Transfer(msg.sender,_to,value); 
    }

    function transferfrom(address _from,address _to,uint256 value) internal returns (bool){  
        require(balanceOf[_from]>=value);
        balanceOf[_from] -= value;
        balanceOf[_to] += value;  
        emit Transfer(_from,_to,value);  
        return true; 
    }

    function TakeLoan(uint256 value) public payable {  
        require(balanceOf[Owner] >= rate*value, "Insuffecient Funds");  
        // ledger at Owner 
        Loans[msg.sender] = value;  
        // sender acccount with BRs
        balanceOf[msg.sender] += rate*value;  
        // Owner account with BRs
        balanceOf[Owner] -= rate*value; 
        // sender account with tokens
        swaptoken.Amount[msg.sender] -= value; 
        // Owner account with tokens  
        swaptoken.Amount[Owner] += value; 
        // time at taking loan
        Time1[msg.sender] = block.timestamp();   
        emit takeloan(Owner,msg.sender,value);       
    } 

    function LoanReturn() public{ 
        // time while returning loan
        Time2[msg.sender] = block.timestamp();
        // time in hours   
        uint256 time = (Time2[msg.sender] - Time1[msg.sender])/3600; 
        // Interest - 10% per hour 
        uint256 interest = Loans[msg.sender]*time*10 ;     
        // Total Amount to be returned = Loan AMount + interest
        uint256 Total = Loans[msg.sender]*rate + interest;     
        transferfrom(msg.sender,Owner,Total);  
        // reduction of tokens from Owner account
        swaptoken.Amount[Owner] -= Loans[msg.sender]; 
        // Returning sufficent tokens to sender address
        swaptoken.Amount[msg.sender] += Loans[msg.sender];
        // Amount to be paid form sender in ledger is 0
        Loans[msg.sender] = 0;     

        emit loanreturn(msg.sender,Owner,Loans[msg.sender]);  

    }
}
