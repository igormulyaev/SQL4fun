class CMults {
  private ulong[] m;
  private long length;

  public CMults (long len) {
    length = len;
    m = new ulong[(length + 32) >> 5];
  }
  
  public ulong Val (long n) {
    long p1 = n >> 5;
    int p2 = ((int)(n & 31)) << 1;
    return (m[p1] >> p2) & 3ul;
  }

  public void Inc (long n) {
    long p1 = n >> 5;
    int p2 = ((int)(n & 31)) << 1;
    ulong v = (m[p1] >> p2) & 3ul;

    if (v < 3) {
      ++v;
      m[p1] |= v << p2;
    }
  }
}