// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;  
 
contract SwapToken{    
    
    string public name = "SwapToken"; 
    string public symbol = "ST";   
    uint256 public TotalSupply = 100;            
 
    mapping(address => uint256) public Amount; // Leadger of swapether tokens 
 
    constructor(){  
        Amount[msg.sender] = TotalSupply; 
    }   
    
    event Trans(address indexed _from,address indexed _to,uint value);

    function Transfer(address _to,uint value) public returns(bool) {  
        require(Amount[msg.sender] >= value); 
        Amount[msg.sender] -= value;
        Amount[_to] += value; 
        emit Trans(msg.sender,_to,value);  
        return true;
    } 
    function Trasferfrom(address _from,address _to,uint256 value) public returns(bool){
        require(Amount[_from] >= value);
        Amount[_from] -= value; 
        Amount[_to] += value; 
        emit Trans(_from,_to,value); 
        return true;
    } 

} 
