﻿namespace eCinema.Core
{
    public class MovieDto : BaseDto
    {
        public string Title { get; set; } = null!;
        public string Description { get; set; } = null!;
        public string Author { get; set; } = null!;
        public int ReleaseYear { get; set; }
        public int Length { get; set; }
        public int Duration { get; set; }
        public int NumberOfViews { get; set; }

        public int LanguageId { get; set; }
        public LanguageDto Language { get; set; } = null!;

        public int ProductionId { get; set; }
        public ProductionDto Production { get; set; } = null!;

        public int PhotoId { get; set; }
        public PhotoDto Photo { get; set; } = null!;
    }
}
