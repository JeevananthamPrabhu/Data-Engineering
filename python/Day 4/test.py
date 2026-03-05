def add(a,b):
    return a+b
import unittest
class Test(unittest.TestCase):
    def test_posi(self):
        self.assertEqual(add(2,5),7)
    def test_neg(self):
        self.assertTrue(add(-1,-3)==-4)
    def test_diff(self):
        self.assertFalse(add(-1,2)==-1)
if __name__=='__main__':
    unittest.main()