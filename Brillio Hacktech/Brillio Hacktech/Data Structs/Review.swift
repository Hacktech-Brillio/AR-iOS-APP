//
//  Review.swift
//  Brillio Hacktech
//
//  Created by Vlad Marian on 26.10.2024.
//

import Foundation

struct ReviewResponse: Codable {
    let status: String
    let requestId: String
    let parameters: ReviewParameters
    let data: ReviewData

    enum CodingKeys: String, CodingKey {
        case status
        case requestId = "request_id"
        case parameters, data
    }
}

struct ReviewParameters: Codable {
    let asin: String
    let country: String
    let sortBy: String
    let verifiedPurchasesOnly: Bool
    let imagesOrVideosOnly: Bool
    let currentFormatOnly: Bool
    let starRating: String
    let page: Int

    enum CodingKeys: String, CodingKey {
        case asin, country
        case sortBy = "sort_by"
        case verifiedPurchasesOnly = "verified_purchases_only"
        case imagesOrVideosOnly = "images_or_videos_only"
        case currentFormatOnly = "current_format_only"
        case starRating = "star_rating"
        case page
    }
}

struct ReviewData: Codable {
    let asin: String
    let totalReviews: Int
    let totalRatings: Int
    let country: String
    let domain: String
    let reviews: [Review]

    enum CodingKeys: String, CodingKey {
        case asin, totalReviews = "total_reviews", totalRatings = "total_ratings"
        case country, domain, reviews
    }
}

struct Review: Codable, Identifiable {
    let id: String
    let title: String
    let comment: String
    let starRating: String
    let link: String
    let author: String
    let authorAvatar: String
    let reviewDate: String
    let isVerifiedPurchase: Bool
    let helpfulVoteStatement: String?
    let reviewedProductAsin: String
    let reviewImages: [String]
    let reviewVideo: ReviewVideo?

    enum CodingKeys: String, CodingKey {
        case id = "review_id"
        case title = "review_title"
        case comment = "review_comment"
        case starRating = "review_star_rating"
        case link = "review_link"
        case author = "review_author"
        case authorAvatar = "review_author_avatar"
        case reviewDate = "review_date"
        case isVerifiedPurchase = "is_verified_purchase"
        case helpfulVoteStatement = "helpful_vote_statement"
        case reviewedProductAsin = "reviewed_product_asin"
        case reviewImages = "review_images"
        case reviewVideo = "review_video"
    }
}

struct ReviewVideo: Codable {
    let streamUrl: String
    let closedCaptionsUrl: String?
    let thumbnailUrl: String?

    enum CodingKeys: String, CodingKey {
        case streamUrl = "stream_url"
        case closedCaptionsUrl = "closed_captions_url"
        case thumbnailUrl = "thumbnail_url"
    }
}
