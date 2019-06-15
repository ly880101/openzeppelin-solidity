pragma solidity >=0.4.0 <0.6.0;
      import "remix_tests.sol"; // this import is automatically injected by Remix.
    
      // file name has to end with '_test.sol'
      contract test_1 {
        string[] strArr;
        uint256 public cliff = 60;
        uint256 public start = 1560521400;
        uint256 public duration = 300;
        uint256 s;
        uint256 d;
        uint256 z;
        
        function beforeAll() public {
          // here should instantiate tested contract
          d = block.timestamp;
          z = d-start;
          s = z/duration;
          strArr.push("123123");
          Assert.equal(uint(4), uint(3), "error in before all function");
        }

        function check1() public {
          // use 'Assert' to test the contract
          Assert.equal(uint(2), uint(1), "error message");
          Assert.equal(uint(2), uint(2), "error message");
        }

        function check2() public pure returns (bool) {
          // use the return value (true or false) to test the contract
          return true;
        }
      }

    contract test_2 {

      function beforeAll() public {
        // here should instantiate tested contract
        Assert.equal(uint(4), uint(3), "error in before all function");
      }

      function check1() public {
        // use 'Assert' to test the contract
        Assert.equal(uint(2), uint(1), "error message");
        Assert.equal(uint(2), uint(2), "error message");
      }

      function check2() public view returns (bool) {
        // use the return value (true or false) to test the contract
        return true;
      }
    }