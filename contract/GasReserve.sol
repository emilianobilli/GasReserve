pragma solidity 0.5.12;


contract GasReserve {
    uint256[] g;

    function reserveGas(uint256 quantity) internal {
        if (quantity > 0)
            reserve(quantity);
    }
    
    function releaseGas(uint256 quantity) internal {
        if (quantity > 0 && quantity <= g.length)
            release(quantity);
    }
    
    function gasLen() internal view returns (uint256) {
        return g.length;
    }
    
    function getReserveAddr () private pure returns(uint256 reserve) {
        uint256 gaddr;
        assembly {
            gaddr := g_slot
        }
        return uint256(keccak256(abi.encode(gaddr)));
    }
    
    function reserve(uint256 quantity) private {
        uint256 len = g.length;
        uint256 start = getReserveAddr() + len;
        uint256 end = start + quantity;
        
        len = len + quantity;
        
        for (uint256 i = start; i < end; i ++) {
            assembly {
                sstore(i,1)
            }
        }
        assembly {
            sstore(g_slot, len)
        }
    }
    
    function release(uint256 quantity) private {
        uint256 len = g.length;
        uint256 start = getReserveAddr() + (len - quantity);
        uint256 end = getReserveAddr() + len;
        
        len = len - quantity;
        
        for (uint256 i = start; i < end; i++) {
            assembly {
                sstore(i,0)
            }
        }
        assembly {
            sstore(g_slot, len)
        }
    }
    
}