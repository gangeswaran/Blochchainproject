# Blochchainproject
Various problems on industrial areas
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract BookRegistry {

    struct Book {

        string title;

        string author;

        uint256 year;

        address owner;

    }

    mapping (uint256 => Book) public books;

    uint256 public bookCount = 0;

    event BookAdded(uint256 bookId, string title, string author, uint256 year, address owner);

    event BookOwnershipChanged(uint256 bookId, address previousOwner, address newOwner);

    function addBook(string memory _title, string memory _author, uint256 _year) public {

        bookCount++;

        books[bookCount] = Book(_title, _author, _year, msg.sender);

        emit BookAdded(bookCount, _title, _author, _year, msg.sender);

    }

    function changeBookOwnership(uint256 _bookId, address _newOwner) public {

        require(books[_bookId].owner == msg.sender, "Only the current owner can change the ownership of the book.");

        books[_bookId].owner = _newOwner;

        emit BookOwnershipChanged(_bookId, msg.sender, _newOwner);

    }

    

    function getBookDetails(uint256 _bookId) public view returns(string memory title, string memory author, uint256 year, address owner) {

        Book memory book = books[_bookId];

        return (book.title, book.author, book.year, book.owner);

    }

}

