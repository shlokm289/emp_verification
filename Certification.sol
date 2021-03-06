pragma solidity ^0.4.24;

contract Certification {

    struct Certificate {
        string candidate_name;
        string org_name;
        string job_title;
        uint256 completionDate;
    }

    mapping(bytes32 => Certificate) public certificates;

    event certificateGenerated(bytes32 _certificateId);

    function stringToBytes32(string memory source) private pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }
        assembly {
                result := mload(add(source, 32))
        }
    }

    function generateCertificate(
        string memory _id,
        string memory _candidate_name,
        string memory _org_name, 
        string memory _job_title, 
        uint256 _completionDate) public {
        bytes32 byte_id = stringToBytes32(_id);
        require(certificates[byte_id].completionDate == 0, "Certificate with given id already exists");
        certificates[byte_id] = Certificate(_candidate_name, _org_name, _job_title, _completionDate);
        emit certificateGenerated(byte_id);
    }

    function getData(string memory _id) public view returns(string memory, string memory, string memory, uint256) {
        bytes32 byte_id = stringToBytes32(_id);
        Certificate memory temp = certificates[byte_id];
        require(temp.completionDate != 0, "No data exists");
        return (temp.candidate_name, temp.org_name, temp.job_title, temp.completionDate);
    }
}