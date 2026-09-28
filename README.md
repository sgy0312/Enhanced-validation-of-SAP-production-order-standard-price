# Enhanced-validation-of-SAP-production-order-standard-price

生产订单标准价增强校验。

> **重要说明**：本仓库代码为**增强点代码**，需通过事务码 **SE19** 植入增强实现，**不可直接作为 SE38 独立报表运行**。

- **源码位置**：`src/enhancement.abap`

## 增强点性质

在创建生产订单（事务码 CO01）时对**成品标准成本**进行校验，防止在标准成本尚未估算或标准成本价格为空的情况下创建生产订单。

## 触发时机

1. **创建生产订单回车校验**：输入条件回车后进行检查
2. **保存生产订单时校验**：保存时再次进行标准成本校验

## 校验逻辑

- 校验产品是否已完成标准成本估算（`KEKO` 表，`FEH_STA = 'FR'`）
- 校验成品是否有标准成本价格（`MBEW` 表，`LPLPR`）
- 校验联产品（`MAKZ` 表，按 `KUPP1` 关联）是否都有标准成本价格

## 依赖表

| 表名 | 用途 |
|------|------|
| `KEKO` | 产品成本核算结果，判断标准成本估算是否完成 |
| `MBEW` | 物料估价，读取标准成本价格 `LPLPR` |
| `T001W` | 工厂主数据，获取 `BWKEY` |
| `MAKZ` | 联产品物料分配 |

## 部署步骤（SE19）

1. 使用事务码 **SE19** 创建增强实现（参考适用的 BAdI 定义）
2. 将 `src/enhancement.abap` 中的代码植入对应增强方法
3. 激活增强实现，在 CO01 中验证校验逻辑

## 界面预览

1. 创建生产订单，输入条件回车后进行检查校验

<img width="627" height="240" alt="image" src="https://github.com/user-attachments/assets/3cc8cf12-9cd3-40f6-b0f8-6aeb42e668ee" />

2. 在保存生产订单时，进行校验

<img width="577" height="287" alt="image" src="https://github.com/user-attachments/assets/6f91cb29-3ca9-495d-abc9-6d0fecbd70b5" />

## 最后维护日期

2026-09-28