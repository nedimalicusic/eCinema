using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class MovieValidator : AbstractValidator<MovieUpsertDto>
    {
        public MovieValidator()
        {
            RuleFor(c => c.Title).NotEmpty().NotNull();
            RuleFor(c => c.Description).NotEmpty().NotNull();
            RuleFor(c => c.Author).NotEmpty().NotNull();
            RuleFor(c => c.ReleaseYear).NotNull();
            RuleFor(c => c.Length).NotNull();
            RuleFor(c => c.Duration).NotNull();
            RuleFor(c => c.NumberOfViews).NotNull();
            RuleFor(c => c.LanguageId).NotNull();
            RuleFor(c => c.ProductionId).NotNull();
            RuleFor(c => c.PhotoId).NotNull();
        }
    }
}
