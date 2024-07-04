lllllllllllllll, llllllllllllllI, lllllllllllllIl, lllllllllllllII, llllllllllllIll = set, print, range, open, len

def lIllllIlIIlllIllII(IIIlIIlllIlIlIlIlI):
 IlIIlIllIllIIlllIl = {}
 for IIIlllIlIIIllllIlI in lllllllllllllll(IIIlIIlllIlIlIlIlI):
  IlIIlIllIllIIlllIl[IIIlllIlIIIllllIlI] = IIIlIIlllIlIlIlIlI.count(IIIlllIlIIIllllIlI)
 return IlIIlIllIllIIlllIl

def lllIllIIllllllIlIl(IIlIllIlIllIlllIll):
 with lllllllllllllII(IIlIllIlIllIlllIll) as llIlIlIllIlIIlllIl:
  llIIllIIllIIIIlIIl = 0
  lIIIIlIIIlIIllIIll = 0
  for llIllIIllIllIllIIl in llIlIlIllIlIIlllIl:
   IlIIlIllIllIIlllIl = lIllllIlIIlllIllII(llIllIIllIllIllIIl)
   if 2 in IlIIlIllIllIIlllIl.values():
    llIIllIIllIIIIlIIl += 1
   if 3 in IlIIlIllIllIIlllIl.values():
    lIIIIlIIIlIIllIIll += 1
 return llIIllIIllIIIIlIIl * lIIIIlIIIlIIllIIll

def llIIlIlllIIIIIlllI(IIlIllIlIllIlllIll):
 with lllllllllllllII(IIlIllIlIllIlllIll) as llIlIlIllIlIIlllIl:
  lllIIIIIIlllIIllII = llIlIlIllIlIIlllIl.readlines()
  for llIlIIIlIIIlIlIIlI in lllllllllllllIl(llllllllllllIll(lllIIIIIIlllIIllII)):
   for IlIlIlIlIIIlllIIlI in lllllllllllllIl(llIlIIIlIIIlIlIIlI + 1, llllllllllllIll(lllIIIIIIlllIIllII)):
    IlIlIlIlllIIlIllII = 0
    for IlllIIlllllIIlIIll in lllllllllllllIl(llllllllllllIll(lllIIIIIIlllIIllII[llIlIIIlIIIlIlIIlI])):
     if lllIIIIIIlllIIllII[llIlIIIlIIIlIlIIlI][IlllIIlllllIIlIIll] != lllIIIIIIlllIIllII[IlIlIlIlIIIlllIIlI][IlllIIlllllIIlIIll]:
      IlIlIlIlllIIlIllII += 1
    if IlIlIlIlllIIlIllII == 1:
     return ''.join([lllIIIIIIlllIIllII[llIlIIIlIIIlIlIIlI][IlllIIlllllIIlIIll] for IlllIIlllllIIlIIll in lllllllllllllIl(llllllllllllIll(lllIIIIIIlllIIllII[llIlIIIlIIIlIlIIlI])) if lllIIIIIIlllIIllII[llIlIIIlIIIlIlIIlI][IlllIIlllllIIlIIll] == lllIIIIIIlllIIllII[IlIlIlIlIIIlllIIlI][IlllIIlllllIIlIIll]])
llllllllllllllI(lllIllIIllllllIlIl('input.txt'))
llllllllllllllI(llIIlIlllIIIIIlllI('input.txt'))