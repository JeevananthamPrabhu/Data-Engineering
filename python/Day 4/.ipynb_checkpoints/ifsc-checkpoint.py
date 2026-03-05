class IFSC:
    bank_codes=['HDFC','SBIN','ICIC']
    def __init__(self,code):
        if not isinstance(code,str):
            raise ValueError("Code must be string")
        self.code=code
    def length(self):
        return len(self.code)==11
    def bank_code(self):
        return self.code[:4].upper() in self.bank_codes
    def rev_char(self):
        return self.code[4]=='0'
    def branch_code(self):
        return self.code[5:].isalnum()
    def check(self):
        return self.length() and self.bank_code() and self.rev_char() and self.branch_code()
import unittest
class Test(unittest.TestCase):
    def test_length(self):
        self.assertTrue(IFSC('HDFC0678679').check())
    def test_bank_code(self):
        self.assertTrue(IFSC('HDFC0123456').check())
    def test_rev_char(self):
        self.assertTrue(IFSC('HDFC0234567').check())
    def test_branch_code(self):
        with self.assertRaises(ValueError):
            self.assertTrue(IFSC([]).check())
    def test_check(self):
        self.assertTrue(IFSC('ICIC0234567').check())
if __name__=='__main__':
    unittest.main()

    
# class IFSC:
#     bank_codes=['HDFC','SBIN']
#     def __init__(self,code):
#         self.code=code
#     def length(self):
#         if len(self.code)==11:
#             print("\nLength Matched")
#             return True
#         print("\nLength Not Matched")
#         return False
#     def bank_code(self):
#         if self.code[:4].upper() in self.bank_codes:
#             print("\nBank Code Matched")
#             return True
#         print("\nBank Code Not Matched")        
#         return False
#     def rev_char(self):
#         if self.code[4]=='0':
#             print("\nReserved Code Matched")
#             return True
#         print("\nReserved Code Not Matched")
#         return False
#     def branch_code(self):
#         if self.code[5:].isalnum():
#             print("\nBranch Code Matched")
#             return True
#         print("\nBranch Code Not Matched")
#         return False
#     def check(self):
#         if self.length() and self.bank_code() and self.rev_char() and self.branch_code():
#             print("\nValid IFSC Code")
#             return True
#         print("\nInvalid IFSC Code")
#         return False
# import unittest
# class Test(unittest.TestCase):
#     def test_length(self):
#         self.assertTrue(IFSC('HDFC0678679').length())
#     def test_bank_code(self):
#         self.assertTrue(IFSC('HDFC').bank_code())
#     def test_rev_char(self):
#         self.assertTrue(IFSC('HDFC').rev_char())
#     def test_branch_code(self):
#         self.assertTrue(IFSC('HDFC').branch_code())
#     def test_check(self):
#         self.assertTrue(IFSC('ICIC').check())

        