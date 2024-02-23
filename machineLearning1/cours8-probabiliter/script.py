from math import factorial


def proba(n):

   res = factorial(365) / (factorial(365 - n) * 365**n)
   
   return res


print(proba(79))