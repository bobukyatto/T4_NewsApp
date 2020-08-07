//
//  Bookmark.swift
//  NewsApp
//
//  Created by Joel on 5/8/20.
//  Copyright © 2020 M02-4. All rights reserved.
//

import UIKit
import FirebaseFirestoreSwift

class Bookmark: Codable {
    @DocumentID var id: String? = UUID().uuidString;
    var uid: String;
    var type: String;
    var source: String?;
    var title: String;
    var desc: String?;
    var url: String?;
    var urlImg: String;
    var publishDate: Date;
    var content: String?;
    
    init(id: String?, uid: String, type: String, source: String?, title: String, desc: String?, url: String?, urlImg: String, publishDate: Date, content: String?) {
        self.id = id;
        self.uid = uid;
        self.type = type;
        self.source = source;
        self.title = title;
        self.desc = desc;
        self.url = url;
        self.urlImg = urlImg;
        self.publishDate = publishDate;
        self.content = content;
    }
}
