What if cloud infrastructure could be queried and managed with Prolog?

Currently you can run `bundle exec ruby graphs.rb` and you'll get a graph directory segmented by region.
You can query the resulting graphs by loading the files into any Prolog interpreter. API documentation
will expand as the library develops but if you want to use it now then the current use case is basically
just whatever is in `graphs.rb`.

```
$ tree graph
graph
├ us-east-1
│   ├ ec2.pl
│   ├ image.pl
│   ├ key.pl
│   ├ net.pl
│   ├ sg.pl
│   ├ snapshot.pl
│   ├ subnet.pl
│   ├ volume.pl
│   └ vpc.pl
├ us-east-2
│   ├ ec2.pl
│   ├ image.pl
│   ├ key.pl
│   ├ net.pl
│   ├ sg.pl
│   ├ snapshot.pl
│   ├ subnet.pl
│   ├ volume.pl
│   └ vpc.pl
├ us-west-1
│   ├ ec2.pl
│   ├ image.pl
│   ├ key.pl
│   ├ net.pl
│   ├ sg.pl
│   ├ snapshot.pl
│   ├ subnet.pl
│   ├ volume.pl
│   └ vpc.pl
└ us-west-2
    ├ ec2.pl
    ├ image.pl
    ├ key.pl
    ├ net.pl
    ├ sg.pl
    ├ snapshot.pl
    ├ subnet.pl
    ├ volume.pl
    └ vpc.pl
```