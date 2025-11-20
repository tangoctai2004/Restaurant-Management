#!/usr/bin/env python3
"""
Script tự động tải ảnh cho các món ăn Việt Nam
Sử dụng Unsplash Source API (không cần API key)
"""

import os
import requests
import time
from pathlib import Path

# Mapping tên món ăn -> từ khóa tìm kiếm và URL ảnh mẫu từ Unsplash
FOOD_IMAGES = {
    # Phở & Bún
    'pho-bo-tai.jpg': {
        'search': 'pho bo vietnamese',
        'url': 'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=800&q=80'
    },
    'pho-bo-chin.jpg': {
        'search': 'pho bo vietnamese soup',
        'url': 'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=800&q=80'
    },
    'pho-bo-tai-chin.jpg': {
        'search': 'pho bo tai chin',
        'url': 'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800&q=80'
    },
    'pho-ga.jpg': {
        'search': 'pho ga chicken vietnamese',
        'url': 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=800&q=80'
    },
    'bun-cha.jpg': {
        'search': 'bun cha hanoi vietnamese',
        'url': 'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800&q=80'
    },
    'bun-bo-hue.jpg': {
        'search': 'bun bo hue vietnamese',
        'url': 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=800&q=80'
    },
    'bun-rieu-cua.jpg': {
        'search': 'bun rieu cua vietnamese',
        'url': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800&q=80'
    },
    'bun-thit-nuong.jpg': {
        'search': 'bun thit nuong vietnamese',
        'url': 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=800&q=80'
    },
    
    # Cơm
    'com-tam-suon.jpg': {
        'search': 'com tam suon nuong vietnamese rice',
        'url': 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=800&q=80'
    },
    'com-tam-bi-cha.jpg': {
        'search': 'com tam bi cha vietnamese',
        'url': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&q=80'
    },
    'com-ga-nuong.jpg': {
        'search': 'com ga nuong grilled chicken rice',
        'url': 'https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=800&q=80'
    },
    'com-ca-kho.jpg': {
        'search': 'ca kho to vietnamese fish',
        'url': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&q=80'
    },
    'com-thit-kho.jpg': {
        'search': 'thit kho tau vietnamese pork',
        'url': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800&q=80'
    },
    'com-suon-xao.jpg': {
        'search': 'suon xao chua ngot vietnamese',
        'url': 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=800&q=80'
    },
    
    # Gỏi & Nộm
    'goi-cuon.jpg': {
        'search': 'goi cuon fresh spring roll vietnamese',
        'url': 'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800&q=80'
    },
    'goi-du-du.jpg': {
        'search': 'goi du du papaya salad vietnamese',
        'url': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&q=80'
    },
    'nom-hoa-chuoi.jpg': {
        'search': 'nom hoa chuoi banana flower salad',
        'url': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800&q=80'
    },
    'goi-ngo-sen.jpg': {
        'search': 'goi ngo sen lotus root salad',
        'url': 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=800&q=80'
    },
    'goi-buoi.jpg': {
        'search': 'goi buoi pomelo salad vietnamese',
        'url': 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=800&q=80'
    },
    
    # Bánh mì
    'banh-mi-thit.jpg': {
        'search': 'banh mi vietnamese sandwich',
        'url': 'https://images.unsplash.com/photo-1509722747041-616f39b57569?w=800&q=80'
    },
    'banh-mi-pate.jpg': {
        'search': 'banh mi pate vietnamese',
        'url': 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&q=80'
    },
    'banh-mi-xiu-mai.jpg': {
        'search': 'banh mi xiu mai vietnamese',
        'url': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800&q=80'
    },
    'banh-mi-cha-ca.jpg': {
        'search': 'banh mi cha ca vietnamese',
        'url': 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=800&q=80'
    },
    'banh-mi-trung.jpg': {
        'search': 'banh mi trung op la vietnamese',
        'url': 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=800&q=80'
    },
    
    # Chả giò & Chả cá
    'cha-gio.jpg': {
        'search': 'cha gio spring roll vietnamese',
        'url': 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=800&q=80'
    },
    'cha-gio-tom-cua.jpg': {
        'search': 'cha gio tom cua shrimp crab roll',
        'url': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800&q=80'
    },
    'cha-ca.jpg': {
        'search': 'cha ca la vong vietnamese fish',
        'url': 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=800&q=80'
    },
    'cha-com.jpg': {
        'search': 'cha com vietnamese',
        'url': 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=800&q=80'
    },
    'cha-nem-nuong.jpg': {
        'search': 'cha nem nuong grilled vietnamese',
        'url': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&q=80'
    },
    
    # Chè & Đồ ngọt
    'che-dau-xanh.jpg': {
        'search': 'che dau xanh green bean dessert',
        'url': 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=800&q=80'
    },
    'che-dau-do.jpg': {
        'search': 'che dau do red bean dessert',
        'url': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800&q=80'
    },
    'che-buoi.jpg': {
        'search': 'che buoi pomelo dessert',
        'url': 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=800&q=80'
    },
    'che-thai.jpg': {
        'search': 'che thai vietnamese dessert',
        'url': 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=800&q=80'
    },
    'che-troi-nuoc.jpg': {
        'search': 'che troi nuoc glutinous rice ball',
        'url': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&q=80'
    },
    'che-khoai-mon.jpg': {
        'search': 'che khoai mon taro dessert',
        'url': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800&q=80'
    },
    'che-chuoi.jpg': {
        'search': 'che chuoi banana dessert',
        'url': 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=800&q=80'
    },
    'banh-flan.jpg': {
        'search': 'banh flan creme caramel',
        'url': 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=800&q=80'
    },
    
    # Đồ uống
    'ca-phe-den.jpg': {
        'search': 'ca phe den vietnamese black coffee',
        'url': 'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=800&q=80'
    },
    'ca-phe-sua.jpg': {
        'search': 'ca phe sua vietnamese coffee',
        'url': 'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=800&q=80'
    },
    'ca-phe-bac-xiu.jpg': {
        'search': 'ca phe bac xiu vietnamese coffee',
        'url': 'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=800&q=80'
    },
    'tra-da.jpg': {
        'search': 'tra da iced tea vietnamese',
        'url': 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=800&q=80'
    },
    'tra-chanh.jpg': {
        'search': 'tra chanh lemon tea',
        'url': 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=800&q=80'
    },
    'chanh-day.jpg': {
        'search': 'nuoc chanh day passion fruit',
        'url': 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=800&q=80'
    },
    'nuoc-dua.jpg': {
        'search': 'nuoc dua fresh coconut water',
        'url': 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=800&q=80'
    },
    'sinh-to-bo.jpg': {
        'search': 'sinh to bo avocado smoothie',
        'url': 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=800&q=80'
    },
    'sinh-to-xoai.jpg': {
        'search': 'sinh to xoai mango smoothie',
        'url': 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=800&q=80'
    },
    'nuoc-cam.jpg': {
        'search': 'nuoc cam ep orange juice',
        'url': 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=800&q=80'
    },
    
    # Lẩu Việt Nam
    'lau-thai.jpg': {
        'search': 'lau thai hot pot vietnamese',
        'url': 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=800&q=80'
    },
    'lau-cua-dong.jpg': {
        'search': 'lau cua dong crab hot pot',
        'url': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800&q=80'
    },
    'lau-ga-la-e.jpg': {
        'search': 'lau ga la e chicken hot pot',
        'url': 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=800&q=80'
    },
    'lau-ca-lang.jpg': {
        'search': 'lau ca lang fish hot pot',
        'url': 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=800&q=80'
    },
    'lau-tom-chua.jpg': {
        'search': 'lau tom chua sour shrimp hot pot',
        'url': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&q=80'
    },
}

def download_image(url, filepath):
    """Tải ảnh từ URL và lưu vào filepath"""
    try:
        print(f"   Đang tải: {filepath.name}...")
        response = requests.get(url, timeout=30, stream=True)
        response.raise_for_status()
        
        # Lưu file
        with open(filepath, 'wb') as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
        
        print(f"   ✅ Đã tải thành công: {filepath.name}")
        return True
    except Exception as e:
        print(f"   ❌ Lỗi khi tải {filepath.name}: {str(e)}")
        return False

def main():
    """Hàm chính"""
    # Đường dẫn thư mục images
    script_dir = Path(__file__).parent
    images_dir = script_dir / 'web' / 'images'
    
    # Tạo thư mục nếu chưa có
    images_dir.mkdir(parents=True, exist_ok=True)
    
    print("=" * 60)
    print("🍜 SCRIPT TỰ ĐỘNG TẢI ẢNH CHO MÓN ĂN VIỆT NAM")
    print("=" * 60)
    print(f"\n📁 Thư mục lưu ảnh: {images_dir}")
    print(f"📊 Tổng số ảnh cần tải: {len(FOOD_IMAGES)}\n")
    
    success_count = 0
    skip_count = 0
    fail_count = 0
    
    for filename, info in FOOD_IMAGES.items():
        filepath = images_dir / filename
        
        # Kiểm tra xem file đã tồn tại chưa
        if filepath.exists():
            print(f"⏭️  Đã tồn tại: {filename}")
            skip_count += 1
            continue
        
        # Tải ảnh từ URL
        url = info['url']
        if download_image(url, filepath):
            success_count += 1
        else:
            fail_count += 1
        
        # Delay để tránh rate limit
        time.sleep(0.5)
    
    print("\n" + "=" * 60)
    print("📊 KẾT QUẢ:")
    print(f"   ✅ Thành công: {success_count}")
    print(f"   ⏭️  Đã tồn tại: {skip_count}")
    print(f"   ❌ Thất bại: {fail_count}")
    print("=" * 60)
    
    if fail_count > 0:
        print("\n⚠️  Một số ảnh tải thất bại. Bạn có thể:")
        print("   1. Chạy lại script để thử tải lại")
        print("   2. Tải thủ công từ Unsplash: https://unsplash.com/s/photos/vietnamese-food")
        print("   3. Sử dụng ảnh placeholder từ thư mục images/")

if __name__ == '__main__':
    main()

