// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test,console} from "forge-std/Test.sol";
import {SmartDisperse} from "../src/SmartDisperse.sol";
import {MyTestToken} from "../src/MintToken.sol";


contract SmartDisperseTest is Test {

    SmartDisperse smartDisperse;
    MyTestToken myTestToken;

    error OwnableUnauthorizedAccount(address);


    function setUp() external{

        vm.startPrank(vm.addr(1));
        deal(vm.addr(1),12 ether);
        smartDisperse = new SmartDisperse(vm.addr(1));
        myTestToken = new MyTestToken(vm.addr(1));
        vm.stopPrank();

    }

    function testOwners() public {
    
        assertEq(smartDisperse.owner(),vm.addr(1),"smart disperse owner");
        assertEq(myTestToken.owner(),vm.addr(1)," Erc20token owner");

    }


    function test_disperseEther_equalValues() public {

        //setting up the address and values
        address payable[] memory recipients = new address payable[](10);
        
        recipients[0] = payable(vm.addr(2));
        recipients[1] = payable(vm.addr(3));
        recipients[2] = payable(vm.addr(3));
        recipients[3] = payable(vm.addr(4));
        recipients[4] = payable(vm.addr(4));
        recipients[5] = payable(vm.addr(4));
        recipients[6] = payable(vm.addr(4));
        recipients[7] = payable(vm.addr(4));
        recipients[8] = payable(vm.addr(4));
        recipients[9] = payable(vm.addr(4));
       


        
        // recipients[3] = payable(vm.addr(5));
        // recipients[4] = payable(vm.addr(6));

        uint[] memory values = new uint[](10);

        values[0] = uint(1000 wei);
        values[1] = uint(1000 wei);
        values[2] = uint(1000 wei);
        values[3] = uint(1000 wei);
        values[4] = uint(1000 wei);
        values[5] = uint(1000 wei);
        values[6] = uint(1000 wei);
        values[7] = uint(1000 wei);
        values[8] = uint(1000 wei);
        values[9] = uint(1000 wei);

        // values[3] = uint(4 ether);
        // values[4] = uint(2 ether);

        //creating the msg.sender
        address user1 = vm.addr(1);

        vm.startPrank(user1);

        deal(user1,12 ether);

        smartDisperse.disperseEther{value: 10000 wei}(recipients, values);

        // assertEq(recipients[0].balance,1000 wei);
        // assertEq(recipients[1].balance,1000 wei);
        // assertEq(recipients[2].balance,1000 wei);
        // assertEq(recipients[3].balance,4 ether);
        // assertEq(recipients[4].balance,2 ether);
        vm.stopPrank();

    }

    

    function test_disperseEther_unequalValues() public {

        //setting up the address and values
        address payable[] memory recipients = new address payable[](5);
        
        recipients[0] = payable(vm.addr(2));
        recipients[1] = payable(vm.addr(3));
        recipients[2] = payable(vm.addr(4));
        recipients[3] = payable(vm.addr(5));
        recipients[4] = payable(vm.addr(6));

        uint[] memory values = new uint[](5);

        values[0] = uint(1 ether);
        values[1] = uint(2 ether);
        values[2] = uint(3 ether);
        values[3] = uint(4 ether);
        values[4] = uint(2 ether);

        //creating the msg.sender
        address user1 = vm.addr(1);
  


        vm.startPrank(user1);

        //dding some balance to msg.sender i.e user1
     
        deal(user1,14 ether);
    

        smartDisperse.disperseEther{value: 12 ether}(recipients, values);

        assertEq(recipients[0].balance,1 ether);
        assertEq(recipients[1].balance,2 ether);
        assertEq(recipients[2].balance,3 ether);
        assertEq(recipients[3].balance,4 ether);
        assertEq(recipients[4].balance,2 ether);
        assertEq(user1.balance,2 ether);

        vm.stopPrank();

    }

     function test_disperseEther_zerovalue() public {
        address payable[] memory recipients = new address payable[](5);

        recipients[0] = payable(vm.addr(2));
        recipients[1] = payable(vm.addr(3));
        recipients[2] = payable(vm.addr(4));
        recipients[3] = payable(vm.addr(5));
        recipients[4] = payable(vm.addr(6));

        uint[] memory values = new uint[](5);

        values[0] = uint(1 ether);
        values[1] = uint(2 ether);
        values[2] = uint(3 ether);
        values[3] = uint(4 ether);
        values[4] = uint(2 ether);
        address user1 = vm.addr(1);


        //expecting an revert from the cantract call
        vm.expectRevert();

        vm.startPrank(user1);

        console.log("address blance",user1.balance);

        deal(user1,14 ether);
        console.log("address blance",user1.balance);

        smartDisperse.disperseEther(recipients, values);

        assertEq(recipients[0].balance,0 ether);
        assertEq(recipients[1].balance,0 ether);
        assertEq(recipients[2].balance,0 ether);
        assertEq(recipients[3].balance,0 ether);
        assertEq(recipients[4].balance,0 ether);
        assertEq(user1.balance,14 ether);

        vm.stopPrank();
        console.log("final balance",user1.balance);
        console.log("address blance",address(this).balance);

    }

    
    function test_disperseEther_insufficientFunds() public {
        address payable[] memory recipients = new address payable[](5);
        
        recipients[0] = payable(vm.addr(2));
        recipients[1] = payable(vm.addr(3));
        recipients[2] = payable(vm.addr(4));
        recipients[3] = payable(vm.addr(5));
        recipients[4] = payable(vm.addr(6));

        uint[] memory values = new uint[](5);

        values[0] = uint(1 ether);
        values[1] = uint(2 ether);
        values[2] = uint(3 ether);
        values[3] = uint(4 ether);
        values[4] = uint(2 ether);
        address user1 = vm.addr(1);
  

        vm.expectRevert();
        vm.startPrank(user1);

        console.log("address blance",user1.balance);

        deal(user1,10 ether);
        console.log("address blance",user1.balance);

       

        smartDisperse.disperseEther{value: 12 ether}(recipients, values);

        vm.stopPrank();
        console.log("final balance",user1.balance);
        console.log("address vlance",address(this).balance);

    }


   


     function test_SimpleDisperseToken() public  {
      vm.startPrank(vm.addr(1));
      
       myTestToken.mint(vm.addr(1),500 *(10 **9));
       console.log(myTestToken.totalSupply());
       assertEq( myTestToken.totalSupply(),500 *(10 **9), "checking token totalsupply");

       console.log(myTestToken.balanceOf(vm.addr(1)));

       address[] memory recipients = new address[](40);
        
       recipients[0] = vm.addr(2);
recipients[1] = vm.addr(3);
recipients[2] = vm.addr(4);
recipients[3] = vm.addr(5);
recipients[4] = vm.addr(6);
recipients[5] = vm.addr(7);
recipients[6] = vm.addr(8);
recipients[7] = vm.addr(9);
recipients[8] = vm.addr(10);
recipients[9] = vm.addr(11);
recipients[10] = vm.addr(12);
recipients[11] = vm.addr(13);
recipients[12] = vm.addr(14);
recipients[13] = vm.addr(15);
recipients[14] = vm.addr(16);
recipients[15] = vm.addr(17);
recipients[16] = vm.addr(18);
recipients[17] = vm.addr(19);
recipients[18] = vm.addr(20);
recipients[19] = vm.addr(21);
recipients[20] = vm.addr(22);
recipients[21] = vm.addr(23);
recipients[22] = vm.addr(24);
recipients[23] = vm.addr(25);
recipients[24] = vm.addr(26);
recipients[25] = vm.addr(27);
recipients[26] = vm.addr(28);
recipients[27] = vm.addr(29);
recipients[28] = vm.addr(30);
recipients[29] = vm.addr(31);
recipients[30] = vm.addr(32);
recipients[31] = vm.addr(33);
recipients[32] = vm.addr(34);
recipients[33] = vm.addr(35);
recipients[34] = vm.addr(36);
recipients[35] = vm.addr(37);
recipients[36] = vm.addr(38);
recipients[37] = vm.addr(39);
recipients[38] = vm.addr(40);
recipients[39] = vm.addr(41);


        uint[] memory values = new uint[](40);

       values[0] = uint(1* 10**9);
values[1] = uint(2* 10**9);
values[2] = uint(3* 10**9);
values[3] = uint(4* 10**9);
values[4] = uint(2* 10**9);

values[5] = uint(1* 10**9);
values[6] = uint(2* 10**9);
values[7] = uint(3* 10**9);
values[8] = uint(4* 10**9);
values[9] = uint(2* 10**9);

values[10] = uint(1* 10**9);
values[11] = uint(2* 10**9);
values[12] = uint(3* 10**9);
values[13] = uint(4* 10**9);
values[14] = uint(2* 10**9);

values[15] = uint(1* 10**9);
values[16] = uint(2* 10**9);
values[17] = uint(3* 10**9);
values[18] = uint(4* 10**9);
values[19] = uint(2* 10**9);

values[20] = uint(1* 10**9);
values[21] = uint(2* 10**9);
values[22] = uint(3* 10**9);
values[23] = uint(4* 10**9);
values[24] = uint(2* 10**9);

values[25] = uint(1* 10**9);
values[26] = uint(2* 10**9);
values[27] = uint(3* 10**9);
values[28] = uint(4* 10**9);
values[29] = uint(2* 10**9);

values[30] = uint(1* 10**9);
values[31] = uint(2* 10**9);
values[32] = uint(3* 10**9);
values[33] = uint(4* 10**9);
values[34] = uint(2* 10**9);

values[35] = uint(1* 10**9);
values[36] = uint(2* 10**9);
values[37] = uint(3* 10**9);
values[38] = uint(4* 10**9);
values[39] = uint(2* 10**9);

         myTestToken.approve(address(smartDisperse),158 * (10**9));
  
       smartDisperse.disperseTokenSimple(myTestToken,recipients,values);

        assertEq(myTestToken.balanceOf(recipients[0]),1* 10**9);
        assertEq(myTestToken.balanceOf(recipients[1]),2 *10**9);
        assertEq(myTestToken.balanceOf(recipients[2]),3 *10**9);
        assertEq(myTestToken.balanceOf(recipients[3]),4 *10**9);
        assertEq(myTestToken.balanceOf(recipients[4]),2 *10**9);

       vm.stopPrank();

    }

     function test_DisperseToken() public  {
       vm.startPrank(vm.addr(1));
      
       myTestToken.mint(vm.addr(1),500 *(10 **9));
       console.log(myTestToken.totalSupply());
       assertEq( myTestToken.totalSupply(),500 *(10 **9), "checking token totalsupply");

       console.log(myTestToken.balanceOf(vm.addr(1)));

       address[] memory recipients = new address[](40);
        
       recipients[0] = vm.addr(2);
recipients[1] = vm.addr(3);
recipients[2] = vm.addr(4);
recipients[3] = vm.addr(5);
recipients[4] = vm.addr(6);
recipients[5] = vm.addr(7);
recipients[6] = vm.addr(8);
recipients[7] = vm.addr(9);
recipients[8] = vm.addr(10);
recipients[9] = vm.addr(11);
recipients[10] = vm.addr(12);
recipients[11] = vm.addr(13);
recipients[12] = vm.addr(14);
recipients[13] = vm.addr(15);
recipients[14] = vm.addr(16);
recipients[15] = vm.addr(17);
recipients[16] = vm.addr(18);
recipients[17] = vm.addr(19);
recipients[18] = vm.addr(20);
recipients[19] = vm.addr(21);
recipients[20] = vm.addr(22);
recipients[21] = vm.addr(23);
recipients[22] = vm.addr(24);
recipients[23] = vm.addr(25);
recipients[24] = vm.addr(26);
recipients[25] = vm.addr(27);
recipients[26] = vm.addr(28);
recipients[27] = vm.addr(29);
recipients[28] = vm.addr(30);
recipients[29] = vm.addr(31);
recipients[30] = vm.addr(32);
recipients[31] = vm.addr(33);
recipients[32] = vm.addr(34);
recipients[33] = vm.addr(35);
recipients[34] = vm.addr(36);
recipients[35] = vm.addr(37);
recipients[36] = vm.addr(38);
recipients[37] = vm.addr(39);
recipients[38] = vm.addr(40);
recipients[39] = vm.addr(41);


        uint[] memory values = new uint[](40);

       values[0] = uint(1* 10**9);
values[1] = uint(2* 10**9);
values[2] = uint(3* 10**9);
values[3] = uint(4* 10**9);
values[4] = uint(2* 10**9);

values[5] = uint(1* 10**9);
values[6] = uint(2* 10**9);
values[7] = uint(3* 10**9);
values[8] = uint(4* 10**9);
values[9] = uint(2* 10**9);

values[10] = uint(1* 10**9);
values[11] = uint(2* 10**9);
values[12] = uint(3* 10**9);
values[13] = uint(4* 10**9);
values[14] = uint(2* 10**9);

values[15] = uint(1* 10**9);
values[16] = uint(2* 10**9);
values[17] = uint(3* 10**9);
values[18] = uint(4* 10**9);
values[19] = uint(2* 10**9);

values[20] = uint(1* 10**9);
values[21] = uint(2* 10**9);
values[22] = uint(3* 10**9);
values[23] = uint(4* 10**9);
values[24] = uint(2* 10**9);

values[25] = uint(1* 10**9);
values[26] = uint(2* 10**9);
values[27] = uint(3* 10**9);
values[28] = uint(4* 10**9);
values[29] = uint(2* 10**9);

values[30] = uint(1* 10**9);
values[31] = uint(2* 10**9);
values[32] = uint(3* 10**9);
values[33] = uint(4* 10**9);
values[34] = uint(2* 10**9);

values[35] = uint(1* 10**9);
values[36] = uint(2* 10**9);
values[37] = uint(3* 10**9);
values[38] = uint(4* 10**9);
values[39] = uint(2* 10**9);

         myTestToken.approve(address(smartDisperse),158 * (10**9));
  
       smartDisperse.disperseToken(myTestToken,recipients,values);

        assertEq(myTestToken.balanceOf(recipients[0]),1* 10**9);
        assertEq(myTestToken.balanceOf(recipients[1]),2 *10**9);
        assertEq(myTestToken.balanceOf(recipients[2]),3 *10**9);
        assertEq(myTestToken.balanceOf(recipients[3]),4 *10**9);
        assertEq(myTestToken.balanceOf(recipients[4]),2 *10**9);

       vm.stopPrank();
    }

    function test_withdrawERC20Tokens() public  {

      vm.startPrank(vm.addr(1));

      //minting tokens 
      myTestToken.mint(vm.addr(1),500 *(10 **9));

      //checking total supply
      assertEq( myTestToken.totalSupply(),500 *(10 **9), "checking token totalsupply");
     
      //tranfering tokens to smart disperse contract
      myTestToken.transfer(address(smartDisperse),300 *(10**9));

      //checking the balance of the contract
      assertEq(myTestToken.balanceOf(address(smartDisperse)),300 *(10**9));
      console.log(myTestToken.balanceOf(address(smartDisperse)),"Token balance in smart contract");


      // withdrawing the amount
      smartDisperse.withdrawERC20Tokens(myTestToken,200 *(10**9));

      assertEq(myTestToken.balanceOf(vm.addr(1)),400* 10**9);
      assertEq(myTestToken.balanceOf(address(smartDisperse)),100* 10**9);
      vm.stopPrank();

    }


     function test_withdrawERC20Tokens_wrongOwner() public  {

      vm.startPrank(vm.addr(1));

      //minting tokens 
      myTestToken.mint(vm.addr(1),500 *(10 **9));

      //checking total supply
      assertEq( myTestToken.totalSupply(),500 *(10 **9), "checking token totalsupply");
     
      //tranfering tokens to smart disperse contract
      myTestToken.transfer(address(smartDisperse),300 *(10**9));

      //checking the balance of the contract
      assertEq(myTestToken.balanceOf(address(smartDisperse)),300 *(10**9));
      console.log(myTestToken.balanceOf(address(smartDisperse)),"Token balance in smart contract");


      vm.stopPrank();
      
      //expecting revting 
      vm.expectRevert(abi.encodeWithSelector(OwnableUnauthorizedAccount.selector,vm.addr(2)));
      
      //changing the msg.sender for checking revert functionality
      vm.startPrank(vm.addr(2));

      smartDisperse.withdrawERC20Tokens(myTestToken,200 *(10**9));

      assertEq(myTestToken.balanceOf(vm.addr(2)),0);
      assertEq(myTestToken.balanceOf(address(smartDisperse)),300* 10**9);
      vm.stopPrank();

    }

}