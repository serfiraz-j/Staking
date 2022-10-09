// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract StakingContract {
    IERC20 public immutable stakingToken;
    IERC20 public immutable rewardsToken;

    address public owner;

    uint constant public rewardPerToken = 1;

    uint[] invests;

    mapping(address => uint) public balanceOf;

    mapping(address => uint) public durations;

    mapping(address => uint) public rewards;

    constructor(address _stakingToken, address _rewardsToken) {
        owner = msg.sender;
        stakingToken = IERC20(_stakingToken);
        rewardsToken = IERC20(_rewardsToken);
    }

    function calculateReward(address _account) view internal returns(uint){
        uint duration = (block.timestamp - durations[_account]);
        return balanceOf[_account] * duration * rewardPerToken;
    }

    function stake(uint _amount) external updateReward(msg.sender){
        require(_amount > 0, "amount can't be zero.");
        balanceOf[msg.sender] += _amount;
        stakingToken.transferFrom(msg.sender, address(this), _amount);
        invests.push(_amount);
    }

    function withdraw(uint _amount) external updateReward(msg.sender){
        require(_amount > 0, "amount can't be zero.");
        require(balanceOf[msg.sender] > 0, "insufficient funds.");
        balanceOf[msg.sender] -= _amount;
        stakingToken.transfer(msg.sender, _amount);
    }

    function getReward() external updateReward(msg.sender){
        uint reward = rewards[msg.sender];
        require(reward > 0, "No rewards");
        rewards[msg.sender] = 0;
        rewardsToken.transfer(msg.sender, reward);
    }

    function totalInvestedandInvestmends() view external returns(uint , uint,uint256){
        uint total=0;
        for(uint i = 0;i<invests.length;i++){
           total += invests[i];
        }
        return (total,invests.length,block.timestamp);
    } 

    modifier updateReward(address _account) {
        rewards[_account] += calculateReward(_account);
        durations[_account] = block.timestamp;
        _;
    }

}


interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}
