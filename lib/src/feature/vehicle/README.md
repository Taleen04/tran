# Vehicle Check System

نظام التحقق من لوحة السيارة في تطبيق النقل الذكي

## الميزات

- ✅ التحقق من وجود لوحة السيارة في النظام
- ✅ ملء النموذج تلقائياً عند العثور على السيارة
- ✅ عرض معلومات السيارة المفصلة
- ✅ واجهة مستخدم جميلة ومتجاوبة
- ✅ معالجة الأخطاء والرسائل المناسبة

## البنية

### Domain Layer
- `VehicleCheckEntity` - كيان التحقق من السيارة
- `VehicleInfoEntity` - كيان معلومات السيارة

### Data Layer
- `VehicleCheckModel` - نموذج البيانات
- `VehicleInfoModel` - نموذج معلومات السيارة
- `VehicleCheckDataSource` - مصدر البيانات

### Repository Layer
- `VehicleCheckRepository` - مستودع البيانات

### Presentation Layer
- `VehicleCheckBloc` - منطق الأعمال
- `VehicleCheckWidget` - واجهة المستخدم
- `VehicleCheckDemo` - صفحة تجريبية

## الاستخدام

### 1. إضافة BlocProvider

```dart
BlocProvider(
  create: (context) => VehicleCheckBloc(
    repository: VehicleCheckRepository(
      dataSource: VehicleCheckDataSource(),
    ),
  ),
  child: VehicleCheckWidget(
    onVehicleFound: (vehicle) {
      // ملء النموذج تلقائياً
    },
    onVehicleNotFound: () {
      // عرض رسالة عدم وجود السيارة
    },
  ),
)
```

### 2. استخدام الـ Widget

```dart
VehicleCheckWidget(
  onVehicleFound: (VehicleInfoEntity? vehicle) {
    if (vehicle != null) {
      // ملء النموذج ببيانات السيارة
      vehicleTypeController.text = vehicle.type;
      vehicleNameController.text = vehicle.name;
      vehicleColorController.text = vehicle.color;
    }
  },
  onVehicleNotFound: () {
    // عرض رسالة عدم وجود السيارة
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('لم يتم العثور على السيارة في النظام'),
        backgroundColor: Colors.orange,
      ),
    );
  },
)
```

## API Endpoint

```
GET /api/transport/vehicle/check-plate/{plateNumber}
```

### Response Format

```json
{
  "success": true,
  "data": {
    "exists": true,
    "vehicle": {
      "type": "car",
      "name": "Toyota Camry",
      "color": "أبيض",
      "make": "Toyota",
      "model": "Camry",
      "year": 2020,
      "is_assigned": false,
      "assigned_to_current_driver": false
    }
  }
}
```

## الحالات المختلفة

### 1. السيارة موجودة
- عرض معلومات السيارة
- زر "استخدام بيانات السيارة"
- ملء النموذج تلقائياً

### 2. السيارة غير موجودة
- رسالة "لم يتم العثور على السيارة في النظام"
- إمكانية إدخال البيانات يدوياً

### 3. خطأ في الاتصال
- عرض رسالة الخطأ
- إمكانية المحاولة مرة أخرى

## التكامل مع شاشة معلومات السيارة

تم دمج النظام مع شاشة `CarInfoView` بحيث:
- يظهر الـ VehicleCheckWidget في الأعلى
- عند العثور على السيارة، يتم ملء النموذج تلقائياً
- يمكن للمستخدم إدخال البيانات يدوياً إذا لم توجد السيارة

## الاختبار

يمكن استخدام `VehicleCheckDemo` لاختبار النظام بشكل منفصل.
