# Project

面向 TLA+ 规约, 自动生成归纳不变式 (Inductive Invariants)

# References

- [dist-ai](./dist-ai/)
  > Automated Invariant Inference for Distributed Protocols
- [dist-verification](./dist-verification/)
  > Formal Verification of Distributed Protocols
- [tla-tlc-tlaps](./tla-tlc-tlaps/)
  > On TLA+, TLC, and TLAPS
- [fol](./fol/)
  > On (Decidable Fragments of) First-Order Logic
- [invariant-learning](./invariant-learning/)
  > Automated Invariant Inference using Machine Learning

# Roadmap

## TLA/TLAPS

### Intro.
- [TLA+ Video Course by Lamport](https://lamport.azurewebsites.net/video/videos.html)

### Books
> 下面两本书可以交叉着阅读
- [The TLA+ Book](http://lamport.azurewebsites.net/tla/book.html?back-link=learning.html#book)
- [The TLA+ Hyperbook](http://lamport.azurewebsites.net/tla/hyperbook.html?back-link=learning.html#hyperbook)

### Tools
- [TLC Toolbox](http://lamport.azurewebsites.net/tla/toolbox.html)
> 熟练使用, 且需要深入学习源码
- [Apalache](https://apalache.informal.systems/)
> 也需要熟练使用, 很可能也需要学习源码 (这个源码的难度大一些, 暂时先不管)


## Inductive Invariants

- [endive](./tla-tlc-tlaps/arXiv2022%202205.06360%20Plain%20and%20Simple%20Inductive%20Invariant%20Inference%20for%20Distributed%20Protocols%20in%20TLA+.pdf): 这是最重要、最直接的参考文献
  - [endive @ github](https://github.com/will62794/endive): 全面了解实现方法
- [TACAS2018](./invariant/TACAS2018%20Accelerating%20Syntax-Guided%20Invariant%20Synthesis.pdf): 从这篇文章吸取灵感, 用于改进 `endive` 工作
- [FAoC2008](./invariant/FAoC2008%20Property-Directed%20Incremental%20Invariant%20Generation.pdf): 从这篇文章吸取灵感, 用于改进 `endive` 工作
- [IC3](./invariant/VMCAI2011%20SAT-Based%20Model%20Checking%20without%20Unrolling.pdf)