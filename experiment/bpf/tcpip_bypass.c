__section("sk_msg")
int bpf_tcpip_bypass(struct sk_msg_md *msg)
{
   struct sock_key key = {};
   sk_msg_extract4_key(msg, &key);
   msg_redirect_hash(msg, &sock_ops_map, &key, BPF_F_INGRESS);
   return SK_PASS;
}
char ____license[] __section("license") = "GPL";
