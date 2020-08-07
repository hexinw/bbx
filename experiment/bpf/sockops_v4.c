static inline
void bpf_sock_ops_ipv4(struct bpf_sock_ops *skops)
{
   struct sock_key key = {};
   sk_extractv4_key(skops, &key);
   int ret = sock_hash_update(skops, &sock_ops_map, &key, BPF_NOEXIST);
   printk("<<< ipv4 op = %d, port %d --> %d ",
        skops->op, skops->local_port, bpf_ntohl(skops->remote_port));
   if (ret != 0) {
      printk("FAILED: sock_hash_update ret: %d ", ret);
     }
}

__section("sockops")
int bpf_sockops_v4(struct bpf_sock_ops *skops)
{
   uint32_t family, op;
   family = skops->family;
   op = skops->op;
   switch (op) {
     case BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB:
       case BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB:
        if (family == 2) { //AF_INET
           bpf_sock_ops_ipv4(skops);
          }
      break;
     default:
        break;
     }
   return 0;
}
char ____license[] __section("license") ="GPL";
int _version __section("version") = 1;
